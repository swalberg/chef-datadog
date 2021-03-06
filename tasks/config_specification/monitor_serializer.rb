
module ConfigSpecification
  class MonitorSerializer
    def initialize(specification)
      @specification = specification
      @integration_name = specification.integration_name
    end

    def serialize
      %(include_recipe 'datadog::dd-agent'

# Monitor #{specification.name}
#
# Here is the description of acceptable attributes:
#{commented_parameters}
datadog_monitor '#{integration_name}' do
  instances node['datadog']['#{integration_name}']['instances']
  logs node['datadog']['#{integration_name}']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
)
    end

    private

    attr_reader :specification
    attr_reader :integration_name

    def commented_parameters
      "node.datadog.#{integration_name} = #{parameters}".gsub(/^(.*)/, '# \1')
    end

    def parameters
      ParametersSerializer.new(specification).serialize[integration_name]
    end
  end
end
