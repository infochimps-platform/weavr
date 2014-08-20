# -*- coding: utf-8 -*-
module Weavr
  class Blueprint < Resource
    field :blueprint_name, String

    # GET /blueprints
    # Returns the available blueprints.
    def get_blueprints
      connection.resource(:get, 'blueprints')
    end

    # POST /blueprints/:name
    # Creates a blueprint. 
    # example:
    # curl -H "X-Requested-By: ambari" -d @hdp_sample_blueprint.txt -u admin:admin \
    #      -XPOST http://localhost:8080/api/v1/blueprints/blueprint-hwx
    def create services_blueprint_filename
      begin
        data = MultiJson.load File.open(services_blueprint_filename, 'r')      
      rescue Exception => e
        raise e.message, Weavr::BlueprintError
      end
      create_from_data data
    end

    def create_from_data data
      resource_action(:post, data)
      self
    end
  end
end
