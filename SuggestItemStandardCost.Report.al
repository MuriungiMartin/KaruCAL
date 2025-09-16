#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5851 "Suggest Item Standard Cost"
{
    Caption = 'Suggest Item Standard Cost';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Vendor No.","Replenishment System","Costing Method";
            column(ReportForNavId_8129; 8129)
            {
            }

            trigger OnAfterGetRecord()
            begin
                InsertStdCostWksh("No.");
                if CurrentDatetime - WindowUpdateDateTime >= 750 then begin
                  Window.Update(1,"No.");
                  WindowUpdateDateTime := CurrentDatetime;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                WindowUpdateDateTime := CurrentDatetime;
                Window.Open(Text007 + Text008);
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
                    group("Standard Cost")
                    {
                        Caption = 'Standard Cost';
                        field("AmtAdjustFactor[1]";AmtAdjustFactor[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjustment Factor';
                            DecimalPlaces = 0:5;
                            MinValue = 0;
                            NotBlank = true;
                        }
                        field("RoundingMethod[1]";RoundingMethod[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Rounding Method';
                            TableRelation = "Rounding Method";
                        }
                    }
                    group("Indirect Cost %")
                    {
                        Caption = 'Indirect Cost %';
                        field("AmtAdjustFactor[2]";AmtAdjustFactor[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjustment Factor';
                            DecimalPlaces = 0:5;
                            MinValue = 0;
                            NotBlank = true;
                        }
                        field("RoundingMethod[2]";RoundingMethod[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Rounding Method';
                            TableRelation = "Rounding Method";
                        }
                    }
                    group("Overhead Rate")
                    {
                        Caption = 'Overhead Rate';
                        field("AmtAdjustFactor[3]";AmtAdjustFactor[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Adjustment Factor';
                            DecimalPlaces = 0:5;
                            MinValue = 0;
                            NotBlank = true;
                        }
                        field("RoundingMethod[3]";RoundingMethod[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Rounding Method';
                            TableRelation = "Rounding Method";
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            i: Integer;
        begin
            for i := 1 to ArrayLen(AmtAdjustFactor) do
              if AmtAdjustFactor[i] = 0 then
                AmtAdjustFactor[i] := 1;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(AmtAdjustFactor) do
          if AmtAdjustFactor[i] = 0 then
            AmtAdjustFactor[i] := 1;
    end;

    trigger OnPreReport()
    var
        StdCostWkshName: Record "Standard Cost Worksheet Name";
    begin
        if ToStdCostWkshName = '' then
          Error(StrSubstNo(Text004));
        StdCostWkshName.Get(ToStdCostWkshName);

        ToStdCostWksh.LockTable
    end;

    var
        Text004: label 'You must specify a worksheet name to copy to.';
        Text007: label 'Copying worksheet...\\';
        Text008: label 'Item No. #1####################\';
        ToStdCostWksh: Record "Standard Cost Worksheet";
        Window: Dialog;
        ToStdCostWkshName: Code[10];
        RoundingMethod: array [3] of Code[10];
        AmtAdjustFactor: array [3] of Decimal;
        WindowUpdateDateTime: DateTime;

    local procedure InsertStdCostWksh(No2: Code[20])
    begin
        with ToStdCostWksh do begin
          Init;
          Validate("Standard Cost Worksheet Name",ToStdCostWkshName);
          Validate(Type,Type::Item);
          Validate("No.",No2);

          Validate(
            "New Standard Cost",
            RoundAndAdjustAmt("Standard Cost",RoundingMethod[1],AmtAdjustFactor[1]));
          Validate(
            "New Indirect Cost %",
            RoundAndAdjustAmt("Indirect Cost %",RoundingMethod[2],AmtAdjustFactor[2]));
          Validate(
            "New Overhead Rate",
            RoundAndAdjustAmt("Overhead Rate",RoundingMethod[3],AmtAdjustFactor[3]));

          if not Insert(true) then
            Modify(true);
        end;
    end;


    procedure RoundAndAdjustAmt(Amt: Decimal;RoundingMethodCode: Code[10];AmtAdjustFactor: Decimal): Decimal
    var
        RoundingMethod: Record "Rounding Method";
        Sign: Decimal;
    begin
        if Amt = 0 then
          exit(Amt);

        Amt := ROUND(Amt * AmtAdjustFactor,0.00001);

        if RoundingMethodCode <> '' then
          with RoundingMethod do begin
            if Amt >= 0 then
              Sign := 1
            else
              Sign := -1;

            SetRange(Code,RoundingMethodCode);
            Code := RoundingMethodCode;
            "Minimum Amount" := Abs(Amt);
            if Find('=<') then begin
              Amt := Amt + Sign * "Amount Added Before";
              if Precision > 0 then
                Amt := Sign * ROUND(Abs(Amt),Precision,CopyStr('=><',Type + 1,1));
              Amt := Amt + Sign * "Amount Added After";
            end;
          end;

        exit(Amt);
    end;


    procedure SetCopyToWksh(ToStdCostWkshName2: Code[10])
    begin
        ToStdCostWkshName := ToStdCostWkshName2;
    end;


    procedure Initialize(ToStdCostWkshName2: Code[10];AmtAdjustFactor1: Decimal;AmtAdjustFactor2: Decimal;AmtAdjustFactor3: Decimal;RoundingMethod1: Code[10];RoundingMethod2: Code[10];RoundingMethod3: Code[10])
    begin
        ToStdCostWkshName := ToStdCostWkshName2;
        AmtAdjustFactor[1] := AmtAdjustFactor1;
        AmtAdjustFactor[2] := AmtAdjustFactor2;
        AmtAdjustFactor[3] := AmtAdjustFactor3;
        RoundingMethod[1] := RoundingMethod1;
        RoundingMethod[2] := RoundingMethod2;
        RoundingMethod[3] := RoundingMethod3;
    end;
}

