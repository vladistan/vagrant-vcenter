require 'i18n'

module VagrantPlugins
  module VCenter
    module Action
      # This class powers on the VM that the Vagrant provider is managing.
      class PowerOn
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_vcenter::action::power_on')
        end

        def call(env)
          config = env[:machine].provider_config
          # FIXME: Raise a correct exception
          dc = config.vcenter_cnx.serviceInstance.find_datacenter(
               config.datacenter_name) or abort 'datacenter not found'
          root_vm_folder = dc.vmFolder
          vm = root_vm_folder.findByUuid(env[:machine].id)

          # Poweron VM
          env[:ui].info('Powering on VM...')
          vm.PowerOnVM_Task.wait_for_completion
          sleep(20) until env[:machine].communicate.ready?
          @app.call env
        end
      end
    end
  end
end
