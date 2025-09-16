#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9905 "Data Encryption Management"
{
    ApplicationArea = Basic;
    Caption = 'Data Encryption Management';
    Editable = false;
    PageType = Card;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(EncryptionEnabledState;EncryptionEnabledState)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Encryption Enabled';
                Editable = false;
                ToolTip = 'Specifies if an encryption key exists and is enabled on the Microsoft Dynamics NAV Server.';
            }
            field(EncryptionKeyExistsState;EncryptionKeyExistsState)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Encryption Key Exists';
                ToolTip = 'Specifies if an encryption key exists on the Microsoft Dynamics NAV Server.';
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Enable Encryption")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Enable Encryption';
                Enabled = EnableEncryptionActionEnabled;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate an encryption key on the server to enable encryption.';

                trigger OnAction()
                begin
                    EncryptionManagement.EnableEncryption;
                    RefreshEncryptionStatus;
                end;
            }
            action("Import Encryption Key")
            {
                AccessByPermission = System "Tools, Restore"=X;
                ApplicationArea = Basic,Suite;
                Caption = 'Import Encryption Key';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Import the encryption key to a server instance from an encryption key file that was exported from another server instance or saved as a copy when the encryption was enabled.';

                trigger OnAction()
                begin
                    EncryptionManagement.ImportKey;
                    RefreshEncryptionStatus;
                end;
            }
            action("Change Encryption Key")
            {
                AccessByPermission = System "Tools, Restore"=X;
                ApplicationArea = Basic,Suite;
                Caption = 'Change Encryption Key';
                Enabled = ChangeKeyActionEnabled;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Change to a different encryption key file.';

                trigger OnAction()
                begin
                    EncryptionManagement.ChangeKey;
                    RefreshEncryptionStatus;
                end;
            }
            action("Export Encryption Key")
            {
                AccessByPermission = System "Tools, Backup"=X;
                ApplicationArea = Basic,Suite;
                Caption = 'Export Encryption Key';
                Enabled = ExportKeyActionEnabled;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Export the encryption key to make a copy of the key or so that it can be imported on another server instance.';

                trigger OnAction()
                begin
                    EncryptionManagement.ExportKey;
                end;
            }
            action("Disable Encryption")
            {
                AccessByPermission = System "Tools, Restore"=X;
                ApplicationArea = Basic,Suite;
                Caption = 'Disable Encryption';
                Enabled = DisableEncryptionActionEnabled;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Decrypt encrypted data.';

                trigger OnAction()
                begin
                    if EncryptionKeyExistsState then
                      EncryptionManagement.DisableEncryption(false)
                    else
                      EncryptionManagement.DeleteEncryptedDataInAllCompanies;
                    RefreshEncryptionStatus;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        RefreshEncryptionStatus;
    end;

    var
        EncryptionManagement: Codeunit "Cryptography Management";
        EncryptionEnabledState: Boolean;
        EncryptionKeyExistsState: Boolean;
        EnableEncryptionActionEnabled: Boolean;
        ChangeKeyActionEnabled: Boolean;
        ExportKeyActionEnabled: Boolean;
        DisableEncryptionActionEnabled: Boolean;

    local procedure RefreshEncryptionStatus()
    begin
        EncryptionEnabledState := EncryptionEnabled;
        EncryptionKeyExistsState := EncryptionKeyExists;

        EnableEncryptionActionEnabled := not EncryptionEnabledState;
        ExportKeyActionEnabled := EncryptionKeyExistsState;
        DisableEncryptionActionEnabled := EncryptionEnabledState;
        ChangeKeyActionEnabled := EncryptionKeyExistsState;
    end;
}

