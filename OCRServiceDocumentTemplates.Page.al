#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1271 "OCR Service Document Templates"
{
    Caption = 'OCR Service Document Templates';
    PageType = List;
    SourceTable = "OCR Service Document Template";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the OCR document template.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the OCR document template.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(GetDefaults)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Update Document Template List';
                Image = Template;
                Promoted = true;
                ToolTip = 'Check for new document templates that the OCR service supports, and add them to the list.';

                trigger OnAction()
                var
                    OCRServiceMgt: Codeunit "OCR Service Mgt.";
                begin
                    OCRServiceMgt.UpdateOcrDocumentTemplates;
                end;
            }
        }
    }
}

