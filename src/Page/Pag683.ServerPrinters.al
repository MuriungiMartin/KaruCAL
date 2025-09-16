#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 683 "Server Printers"
{
    Caption = 'Server Printers';
    Editable = false;
    LinksAllowed = false;
    PageType = StandardDialog;
    SourceTable = Printer;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(ID;ID)
                {
                    ApplicationArea = Basic;
                    Caption = 'Printer Name';
                    ToolTip = 'Specifies the name of the printer.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Codeunit.Run(Codeunit::"Init. Server Printer Table",Rec);
        if SelectedPrinterName <> '' then begin
          ID := SelectedPrinterName;
          if Find then;
        end;
    end;

    var
        SelectedPrinterName: Text[250];


    procedure SetSelectedPrinterName(NewName: Text[250])
    begin
        SelectedPrinterName := NewName;
    end;


    procedure GetSelectedPrinterName(): Text[250]
    begin
        exit(ID);
    end;
}

