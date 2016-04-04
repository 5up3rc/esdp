-module(dumpetag).

-include_lib("pkt/include/pkt.hrl").

-export([start/0, start/1]).
-export([filename/1]).
-export([init/1]).

-record(state, {
        c               % monitored connections
    }).

-define(TMPDIR, "/tmp/").

%% run packet capture in separate process
init(Arg) ->
    lager:debug("dumpetag:init"),
    epcap:start(Arg),
    loop(#state{
            c = orddict:new()
        }).


start() ->
    start([{filter, "tcp and port 80"},
            {interface, "en0"},
            {chroot, "priv/tmp"}]).
start(Arg) ->
    lager:debug("dumpetag:start:~p", [Arg]),
    spawn(?MODULE, init, [Arg]).


loop(State) ->
    lager:debug("dumpetag:loop"),
    receive
        {packet, DLT, Time, Len, Data} ->
          Packet = pkt:decapsulate({pkt:dlt(DLT), Data}),
          lager:debug("dumpetag:Packet:~p", [Packet]),
          Headers = header(Packet),
          lager:debug("dumpetag:Packet:~p", [Headers]),
          %%P = pkt:decapsulate(Packet),
          %%State1 = match(P, State),
          State1 = match(Packet, State),
          loop(State1);
        {'DOWN', Pid, process, _Object, _Info} ->
            loop(State#state{
                c = orddict:filter(
                    fun (_,V) when V == Pid -> false;
                        (_,_) -> true end,
                    State#state.c)
            });
        Error ->
            error_logger:info_report([{error, Error}])
    end.


% closed connections
match([ #ether{},
        #ipv4{
            saddr = Saddr,
            daddr = Daddr
        },
        #tcp{
            sport = Sport,
            dport = Dport,
            rst = RST,
            fin = FIN
        },
        _Payload],
    #state{
        c = Connections
    } = State) when RST =:= 1; FIN =:= 1 ->

    Info = make_key({{Saddr, Sport}, {Daddr, Dport}}),
    case orddict:find(Info, Connections) of
        {ok, Pid} ->
            Pid ! eof,
            State#state{
                c = orddict:erase(Info, Connections)
            };
        error ->
            State
    end;

% connections in ESTABLISHED state
match([ #ether{},
        #ipv4{
            saddr = Saddr,
            daddr = Daddr
        },
        #tcp{
            sport = Sport,
            dport = Dport,
            syn = 0,
            rst = 0,
            fin = 0,
            ack = 1
        },
        Payload],
    #state{
        c = Connections
    } = State) ->

    Info = make_key({{Saddr, Sport}, {Daddr, Dport}}),
    case orddict:find(Info, Connections) of
        {ok, Pid} ->
            Pid ! {data, Payload},
            State;
        error ->
            {Pid, _Ref} = spawn_monitor(fun() -> dumper() end),
            State#state{c = orddict:store(Info, Pid, Connections)}
    end;
match(_, State) ->
    State.


% canononical representation of the TCP connection
make_key({{_IP, 80}, _} = Key) ->
    Key;
make_key({K2, {_IP, 80} = K1}) ->
    {K1, K2}.


dumper() ->
    dumper([]).
dumper(Payload) ->
    receive
        {data, Data} ->
            dumper([Data|Payload]);
        eof ->
            filer(Payload)
    after
        5000 ->
            filer(Payload)
    end.

filer(Data) ->
    Payload = list_to_binary(lists:reverse(Data)),
    Name = filename(Payload),
    file:write_file(Name, Payload, [append]).

filename(Payload) ->
    lager:debug("got to filename"),
    lager:debug("filename:payload: ~p", [Payload]),
    {match, [Name]} = re:run(Payload, "ETag: \"([a-zA-Z0-9-]+)\"", [{capture, [1], list}]),
    CreatedFileName = ?TMPDIR ++ "etag-" ++ Name,
    lager:debug("file=~s", [CreatedFileName]),
    CreatedFileName.

header(Packet) ->
  todo.
