#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5853 "Copy Standard Cost Worksheet"
{
    Caption = 'Copy Standard Cost Worksheet';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Standard Cost Worksheet";"Standard Cost Worksheet")
        {
            DataItemTableView = sorting("Standard Cost Worksheet Name",Type,"No.");
            column(ReportForNavId_4691; 4691)
            {
            }

            trigger OnAfterGetRecord()
            begin
                InsertStdCostWksh;
                if CurrentDatetime - WindowUpdateDateTime >= 750 then begin
                  Window.Update(1,Type);
                  Window.Update(2,"No.");

                  WindowUpdateDateTime := CurrentDatetime;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;

                if not NoMessage then
                  Message(Text010);
            end;

            trigger OnPreDataItem()
            begin
                FromStdCostWkshName.Get(FromStdCostWkshName.Name);
                SetFilter("Standard Cost Worksheet Name",FromStdCostWkshName.Name);

                WindowUpdateDateTime := CurrentDatetime;
                Window.Open(Text007 + Text008 + Text009);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Copy from")
                    {
                        Caption = 'Copy from';
                        field("FromStdCostWkshName.Name";FromStdCostWkshName.Name)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Standard Cost Worksheet Name';
                            TableRelation = "Standard Cost Worksheet Name";
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        StdCostWkshName: Record "Standard Cost Worksheet Name";
    begin
        if ToStdCostWkshName = '' then
          Error(StrSubstNo(Text003));
        StdCostWkshName.Get(ToStdCostWkshName);

        if FromStdCostWkshName.Name = '' then
          Error(StrSubstNo(Text004));
        FromStdCostWkshName.Get(FromStdCostWkshName.Name);

        ToStdCostWksh.LockTable
    end;

    var
        Text003: label 'You must specify a worksheet name to copy to.';
        Text004: label 'You must specify a worksheet name to copy from.';
        Text007: label 'Copying worksheet...\\';
        Text008: label 'Type               #1##########\';
        Text009: label 'No.                #2##########\';
        Text010: label 'The worksheet has been successfully copied.';
        ToStdCostWksh: Record "Standard Cost Worksheet";
        FromStdCostWkshName: Record "Standard Cost Worksheet Name";
        Window: Dialog;
        ToStdCostWkshName: Code[10];
        NoMessage: Boolean;
        WindowUpdateDateTime: DateTime;

    local procedure InsertStdCostWksh()
    begin
        with ToStdCostWksh do begin
          ToStdCostWksh := "Standard Cost Worksheet";
          "Standard Cost Worksheet Name" := ToStdCostWkshName;
          if not Insert(true) then
            Modify(true);
        end;
    end;


    procedure SetCopyToWksh(ToStdCostWkshName2: Code[10])
    begin
        ToStdCostWkshName := ToStdCostWkshName2;
    end;


    procedure Initialize(FromStdCostWkshName2: Code[10];ToStdCostWkshName2: Code[10];NoMessage2: Boolean)
    begin
        FromStdCostWkshName.Name := FromStdCostWkshName2;
        ToStdCostWkshName := ToStdCostWkshName2;
        NoMessage := NoMessage2;
    end;
}

