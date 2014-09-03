Fabricator(:poms_broadcast, class_name: :"Poms::Broadcast") do
  initialize_with do
    Poms::Builder.process_hash(
      JSON.parse File.read('spec/fixtures/poms_broadcast.json')
    )
  end
end

Fabricator(:poms_broadcast_pippi_langkous, class_name: :"Poms::Broadcast") do
  initialize_with do
    Poms::Builder.process_hash(
      JSON.parse File.read('spec/fixtures/poms_broadcast_pippi.json')
    )
  end
end

Fabricator(:poms_broadcast_multiple_schedule_events, class_name: :"Poms::Broadcast") do
  initialize_with do
    Poms::Builder.process_hash(
      JSON.parse File.read('spec/fixtures/poms_broadcast_multiple_schedule_events.json')
    )
  end
end

Fabricator(:poms_series, class_name: :"Poms::Series") do
  initialize_with do
    Poms::Builder.process_hash(
      JSON.parse File.read('spec/fixtures/poms_series.json')
    )
  end
end

Fabricator(:zapp_broadcasts, class_name: :array) do
  initialize_with do
    hash = JSON.parse File.read('spec/fixtures/poms_zapp.json')
    array = hash['rows'].take(10).map {|item| Poms::Builder.process_hash item['doc']}
    array
  end
end
