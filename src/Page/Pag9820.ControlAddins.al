#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9820 "Control Add-ins"
{
    ApplicationArea = Basic;
    Caption = 'Control Add-ins';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Control Add-in Resource';
    SourceTable = "Add-in";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Add-in Name";"Add-in Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the Client Control Add-in that is registered on the Microsoft Dynamics NAV Server.';
                }
                field("Public Key Token";"Public Key Token")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the public key token that is associated with the Add-in.';
                }
                field(Version;Version)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the version of the Client Control Add-in that is registered on a Microsoft Dynamics NAV Server.';
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the category of the add-in. The following table describes the types that are available:';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the Client Control Add-in.';
                }
                field(Resource;Resource)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the URL to the resource zip file.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Control Add-in Resource")
            {
                Caption = 'Control Add-in Resource';
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Import a control add-in definition from a file.';

                    trigger OnAction()
                    var
                        TempBlob: Record TempBlob;
                        FileManagement: Codeunit "File Management";
                        ResourceName: Text;
                    begin
                        if Resource.Hasvalue then
                          if not Confirm(ImportQst) then
                            exit;

                        ResourceName := FileManagement.BLOBImportWithFilter(
                            TempBlob,ImportTitleTxt,'',
                            ImportFileTxt + ' (*.zip)|*.zip|' + AllFilesTxt + ' (*.*)|*.*','*.*');

                        if ResourceName <> '' then begin
                          Resource := TempBlob.Blob;
                          CurrPage.SaveRecord;

                          Message(ImportDoneMsg);
                        end;
                    end;
                }
                action(Export)
                {
                    ApplicationArea = Basic;
                    Caption = 'Export';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Export a control add-in definition to a file.';

                    trigger OnAction()
                    var
                        TempBlob: Record TempBlob;
                        FileManagement: Codeunit "File Management";
                    begin
                        if not Resource.Hasvalue then begin
                          Message(NoResourceMsg);
                          exit;
                        end;

                        TempBlob.Blob := Resource;
                        FileManagement.BLOBExport(TempBlob,"Add-in Name" + '.zip',true);
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Remove a control add-in from the list if it is no longer in use.';

                    trigger OnAction()
                    begin
                        if not Resource.Hasvalue then
                          exit;

                        Clear(Resource);
                        CurrPage.SaveRecord;

                        Message(RemoveDoneMsg);
                    end;
                }
            }
        }
    }

    var
        AllFilesTxt: label 'All Files';
        ImportFileTxt: label 'Control Add-in Resource';
        ImportDoneMsg: label 'The control add-in resource has been imported.';
        ImportQst: label 'The control add-in resource is already specified.\Do you want to overwrite it?';
        ImportTitleTxt: label 'Import Control Add-in Resource';
        NoResourceMsg: label 'There is no resource for the control add-in.';
        RemoveDoneMsg: label 'The control add-in resource has been removed.';
}

