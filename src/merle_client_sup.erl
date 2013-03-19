-module(merle_client_sup).

-export([start_link/2, init/1]).

-export([start_child/1]).

-behaviour(supervisor).

start_link(Instances, ConnectionsPerInstance) ->
    log4erl:error("Merle client sup STARTING!"),

    {ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []),

    merle_cluster:configure(Instances, ConnectionsPerInstance),

    {ok, Pid}.

start_child(N) ->
    supervisor:start_child(?MODULE, [N]).

init([]) ->
    MCDSpec = {mcd, {merle_client, start_link, []},
                permanent, 5000, worker, dynamic},
    {ok, {{simple_one_for_one, 10, 10}, [MCDSpec]}}.
