require 'i18n'

module VagrantPlugins
  module VCenter
    module Action
      # This class destroy the VM created by the Vagrant provider.
      class Destroy
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_vcenter::action::destroy')
        end

        def call(env)
          config = env[:machine].provider_config
          # FIXME: Raise a correct exception
          dc = config.vcenter_cnx.serviceInstance.find_datacenter(
               config.datacenter_name) or abort 'datacenter not found'
          root_vm_folder = dc.vmFolder
          vm = root_vm_folder.findByUuid(env[:machine].id)

          # Poweron VM
          env[:ui].info('Destroying VM...')
          vm.Destroy_Task.wait_for_completion
          env[:machine].id = nil
        end
      end
    end
  end
end
