module Weavr
  class Blueprint < Resource
    field :blueprint_name,    String

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
        f = File.open(services_blueprint_filename, 'r')
      rescue Exception => e
        puts e
        exit 1
      end

      begin
        data = MultiJson.load(f)
      rescue MultiJson::ParseError => e
        puts e.data
        puts e.cause
        exit 1
      end

      create_from_data data
      # resource_action(:post, data)
      # self
    end

    def create_from_data data
      resource_action(:post, data)
      self
    end
  end
end
