#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6007 "Insert Fault/Resol. Relations"
{
    Caption = 'Insert Fault/Resol. Codes Relationships';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UsageCategory = Tasks;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FromDate;FromDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'From Date';
                    }
                    field(ToDate;ToDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'To Date';
                    }
                    field(BasedOnServItemGr;BasedOnServItemGr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Relation Based on Service Item Group';
                    }
                    field(RetainManuallyInserted;RetainManuallyInserted)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Retain Manually Inserted Rec.';
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

    trigger OnInitReport()
    begin
        RetainManuallyInserted := true;
    end;

    trigger OnPostReport()
    begin
        Clear(CalcFaultResolutionRelation);
        CalcFaultResolutionRelation.CopyResolutionRelationToTable(FromDate,ToDate,BasedOnServItemGr,RetainManuallyInserted);
    end;

    trigger OnPreReport()
    begin
        if FromDate = 0D then
          Error(Text000);
        if ToDate = 0D then
          Error(Text001);
    end;

    var
        Text000: label 'You must fill in the From Date field.';
        Text001: label 'You must fill in the To Date field.';
        CalcFaultResolutionRelation: Codeunit "FaultResolRelation-Calculate";
        FromDate: Date;
        ToDate: Date;
        BasedOnServItemGr: Boolean;
        RetainManuallyInserted: Boolean;


    procedure InitializeRequest(DateFrom: Date;ToDateFrom: Date;BasedOnServItemGrFrom: Boolean;RetainManuallyInsertedFrom: Boolean)
    begin
        FromDate := DateFrom;
        ToDate := ToDateFrom;
        BasedOnServItemGr := BasedOnServItemGrFrom;
        RetainManuallyInserted := RetainManuallyInsertedFrom;
    end;
}

