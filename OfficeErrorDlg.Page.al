#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1608 "Office Error Dlg"
{
    Caption = 'Something went wrong';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            label(Control3)
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = false;
                HideValue = true;
                ShowCaption = false;
            }
            field(ErrorText;ErrorText)
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                MultiLine = true;
                ShowCaption = false;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var
        OfficeErrorEngine: Codeunit "Office Error Engine";
    begin
        ErrorText := OfficeErrorEngine.GetError;
    end;

    var
        ErrorText: Text;
}

