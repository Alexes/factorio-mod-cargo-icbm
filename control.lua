function is_a_go(circuit_network)
    if circuit_network ~= nil then
        return circuit_network.get_signal { type = "virtual", name = "signal-explosion" } > 0
    else
        return false
    end
end

silo_cache = nil

script.on_nth_tick(60, function(event)
    if silo_cache == nil then
        silo_cache = {}
        for _, silo in pairs(game.surfaces["nauvis"].find_entities_filtered { type = "rocket-silo" }) do
            silo_cache[silo.unit_number] = silo
        end
    end

    for _, silo in pairs(silo_cache) do
        if silo.valid and silo.rocket_silo_status == defines.rocket_silo_status.rocket_ready then
            if is_a_go(silo.get_circuit_network(defines.wire_connector_id.circuit_green)) or
                is_a_go(silo.get_circuit_network(defines.wire_connector_id.circuit_red)) then
                silo.launch_rocket { type = defines.cargo_destination.surface, surface = silo.surface }
            end
        end
    end
end)

function silo_created(event)
    silo_cache[event.entity.unit_number] = event.entity
end

function silo_removed(event)
    silo_cache[event.entity.unit_number] = nil
end

script.on_event(defines.events.on_built_entity, silo_created, { { filter = "name", name = "rocket-silo" } })
script.on_event(defines.events.on_robot_built_entity, silo_created, { { filter = "name", name = "rocket-silo" } })

script.on_event(defines.events.on_entity_died, silo_removed, { { filter = "name", name = "rocket-silo" } })
script.on_event(defines.events.on_player_mined_entity, silo_removed, { { filter = "name", name = "rocket-silo" } })
script.on_event(defines.events.on_robot_mined_entity, silo_removed, { { filter = "name", name = "rocket-silo" } })
