#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 699 "Dimension Set Entries FactBox"
{
    Caption = 'Dimensions';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Dimension Set Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Dimension Code";"Dimension Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension.';
                }
                field("Dimension Name";"Dimension Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the descriptive name of the Dimension Code field.';
                    Visible = false;
                }
                field("Dimension Value Code";"Dimension Value Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value.';
                }
                field("Dimension Value Name";"Dimension Value Name")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the descriptive name of the Dimension Value Code field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if FormCaption <> '' then
          CurrPage.Caption := FormCaption;
    end;

    trigger OnInit()
    begin
        if FormCaption <> '' then
          CurrPage.Caption := FormCaption;
    end;

    var
        FormCaption: Text[250];


    procedure SetFormCaption(NewFormCaption: Text[250])
    begin
        FormCaption := CopyStr(NewFormCaption + ' - ' + CurrPage.Caption,1,MaxStrLen(FormCaption));
    end;
}

