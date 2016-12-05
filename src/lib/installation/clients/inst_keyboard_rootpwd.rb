# encoding: utf-8

# ------------------------------------------------------------------------------
# Copyright (c) 2016 SUSE LINUX GmbH, Nuernberg, Germany.
#
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, contact Novell, Inc.
#
# To contact Novell about this file by physical or electronic mail, you may find
# current contact information at www.novell.com.
# ------------------------------------------------------------------------------

require "users/widgets"
require "y2country/widgets"


module Installation
  # This library provides a simple dialog for setting new password for the
  # system adminitrator (root) and keyboard layout.
  # The new password is not stored here, just set in UsersSimple module
  # and stored later during inst_finish.
  class InstKeyboardRootpwd
    include Yast::Logger
    include Yast::I18n
    include Yast::UIShortcuts

    def run
      Yast.import "UI"
      Yast.import "Mode"
      Yast.import "CWM"

      textdomain "installation"

      # We do not need to create a wizard dialog in installation, but it's
      # helpful when testing all manually on a running system
      Yast::Wizard.CreateDialog if separate_wizard_needed?

      Yast::Wizard.SetTitleIcon("yast-users")
      Yast::Wizard.EnableAbortButton

      ret = Yast::CWM.show(
        content,
        # Title for root-password dialogue
        caption: _("Keyboard Layout and Password for the System Administrator \"root\"")
      )

      Yast::Wizard.CloseDialog if separate_wizard_needed?

      ret
    end

  private

    # Returns a UI widget-set for the dialog
    def content
      VBox(
        VStretch(),
        ::Y2Country::KeyboardSelectionWidget.new,
        VStretch(),
        ::Users::PasswordWidget.new,
        VStretch()
      )
    end

    # Returns whether we need/ed to create new UI Wizard
    def separate_wizard_needed?
      Yast::Mode.normal
    end
  end
end
