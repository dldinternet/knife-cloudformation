require 'knife-cloudformation/cloudformation_base'
require File.join(File.dirname(__FILE__), 'cloudformation_create')

class Chef
  class Knife
    class CloudformationUpdate < Knife
      banner 'knife cloudformation update NAME'

      include KnifeCloudformation::KnifeBase
      include CloudformationCreate::Options

      def create_stack(name, stack)
        begin
          res = aws_con.update_stack(name, stack)
        rescue => e
          ui.fatal "Failed to update stack #{name}. Reason: #{e}"
          _debug(e, "Generated template used:\n#{_format_json(stack['TemplateBody'])}")
          exit 1
        end
      end

      def action_in_progress?(name)
        stack_status(name) == 'UPDATE_IN_PROGRESS'
      end

      def action_successful?(name)
        stack_status(name) == 'UPDATE_COMPLETE'
      end

    end
  end
end
