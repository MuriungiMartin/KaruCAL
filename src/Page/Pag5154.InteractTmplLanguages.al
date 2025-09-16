#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5154 "Interact. Tmpl. Languages"
{
    Caption = 'Interact. Tmpl. Languages';
    DataCaptionFields = "Interaction Template Code";
    PageType = List;
    SourceTable = "Interaction Tmpl. Language";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Interaction Template Code";"Interaction Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the interaction template that you have selected.';
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the interaction template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the description of the interaction template language. This field will not be displayed in the Word attachment.';
                }
                field(Attachment;"Attachment No." <> 0)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Attachment';
                    ToolTip = 'Specifies if the attachment that is linked to the segment line is inherited or unique.';

                    trigger OnAssistEdit()
                    begin
                        if "Attachment No." = 0 then
                          CreateAttachment
                        else
                          OpenAttachment;

                        CurrPage.Update;
                    end;
                }
                field("Custom Layout Code";"Custom Layout Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the report layout.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UpdateAttachments("Custom Layout Code");
                    end;
                }
                field(CustLayoutDescription;CustomReportLayoutDescription)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Custom Layout';
                    ToolTip = 'Specifies the report layout that will be used.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustomReportLayout: Record "Custom Report Layout";
                    begin
                        if CustomReportLayout.LookupLayoutOK(Report::"Email Merge") then begin
                          Validate("Custom Layout Code",CustomReportLayout.Code);
                          Modify(true);

                          CustomReportLayoutDescription := CustomReportLayout.Description;
                          UpdateAttachments("Custom Layout Code");
                        end;
                    end;

                    trigger OnValidate()
                    var
                        CustomReportLayout: Record "Custom Report Layout";
                    begin
                        if CustomReportLayoutDescription = '' then begin
                          Validate("Custom Layout Code",'');
                          Modify(true);
                        end else begin
                          CustomReportLayout.SetRange("Report ID",Report::"Email Merge");
                          CustomReportLayout.SetFilter(Description,StrSubstNo('@*%1*',CustomReportLayoutDescription));
                          if not CustomReportLayout.FindFirst then
                            Error(CouldNotFindCustomReportLayoutErr,CustomReportLayoutDescription);

                          Validate("Custom Layout Code",CustomReportLayout.Code);
                          Modify(true);
                        end;

                        UpdateAttachments("Custom Layout Code");
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Attachment")
            {
                Caption = '&Attachment';
                Image = Attachments;
                action(Open)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
                    Image = Edit;
                    ShortCutKey = 'Return';
                    ToolTip = 'Open the attachment.';

                    trigger OnAction()
                    begin
                        OpenAttachment;
                    end;
                }
                action(Create)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create';
                    Ellipsis = true;
                    Image = New;
                    ToolTip = 'Create an attachment.';

                    trigger OnAction()
                    begin
                        CreateAttachment;
                    end;
                }
                action("Copy &from")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &from';
                    Ellipsis = true;
                    Image = Copy;
                    ToolTip = 'Copy from an attachment.';

                    trigger OnAction()
                    begin
                        CopyFromAttachment;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;
                    ToolTip = 'Import an attachment.';

                    trigger OnAction()
                    begin
                        ImportAttachment;
                    end;
                }
                action("E&xport")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xport';
                    Ellipsis = true;
                    Image = Export;
                    ToolTip = 'Export an attachment.';

                    trigger OnAction()
                    begin
                        ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;
                    ToolTip = 'Remove an attachment.';

                    trigger OnAction()
                    begin
                        RemoveAttachment(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("Custom Layout Description");
        CustomReportLayoutDescription := "Custom Layout Description";
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Custom Layout Description");
        CustomReportLayoutDescription := "Custom Layout Description";
    end;

    var
        CustomReportLayoutDescription: Text;
        CouldNotFindCustomReportLayoutErr: label 'There is no Custom Report Layout with %1 in the description.', Comment='%1 Description of Custom Report Layout';

    local procedure UpdateAttachments(NewCustomLayoutCode: Code[20])
    begin
        if NewCustomLayoutCode <> '' then
          CreateAttachment
        else
          if xRec."Custom Layout Code" <> '' then
            RemoveAttachment(false);

        CalcFields("Custom Layout Description");
        CurrPage.Update;
    end;
}

