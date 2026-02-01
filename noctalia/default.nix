{ config, pkgs, lib, ... }:
{
  home-manager.users.${config.var.username} = lib.mkIf pkgs.stdenv.isLinux ({ pkgs, ... }: {
    xdg.configFile."noctalia/config.xml".text = ''
      <root>
      	<bar>
      		<anchor>top</anchor>
      		<layer>top</layer>
          <modules>
            <module>workspaces</module>
            <module>clock</module>
            <module>tray</module>
          </modules>
      	</bar>
            </root>
          '';
        });
      }
      