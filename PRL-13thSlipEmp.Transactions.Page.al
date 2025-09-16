#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99251 "PRL-13thSlip Emp. Transactions"
{
    PageType = List;
    SourceTable = UnknownTable99251;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        blnIsLoan:=false;
                        if objTransCodes.Get("Transaction Code") then
                          "Transaction Name":=objTransCodes."Transaction Name";
                          "Payroll Period":=SelectedPeriod;
                          "Period Month":=PeriodMonth;
                          "Period Year":=PeriodYear;
                    end;
                }
                field("Transaction Name";"Transaction Name")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field("Recurance Index";"Recurance Index")
                {
                    ApplicationArea = Basic;
                }
                field("Current Instalment";"Current Instalment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Payroll Period";"Payroll Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed,false);
        if objPeriod.Find('-') then
        begin
            SelectedPeriod:=objPeriod."Date Openned";
            PeriodName:=objPeriod."Period Name";
            PeriodMonth:=objPeriod."Period Month";
            PeriodYear:=objPeriod."Period Year";
            //objEmpTrans.RESET;
            //objEmpTrans.SETRANGE("Payroll Period",SelectedPeriod);
        end;

        //Filter per period  - Dennis
        SetFilter("Payroll Period",Format(objPeriod."Date Openned"));
        SetFilter("Current Instalment",Format(objPeriod."Current Instalment"));
    end;

    var
        objTransCodes: Record UnknownRecord61082;
        SelectedPeriod: Date;
        objPeriod: Record UnknownRecord99250;
        PeriodName: Text[30];
        PeriodTrans: Record UnknownRecord99252;
        PeriodMonth: Integer;
        PeriodYear: Integer;
        blnIsLoan: Boolean;
        objEmpTrans: Record UnknownRecord99251;
        transType: Text[30];
        objOcx: Codeunit "prPayrollProcessing 13thSlip";
        strExtractedFrml: Text[30];
        curTransAmount: Decimal;
        empCode: Text[30];
}

