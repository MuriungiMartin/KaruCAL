#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99251 "Post 13thSlip Salaries"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable99201;UnknownTable99201)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                HRMEmployeeD.Reset;
                HRMEmployeeD.SetRange("No.","Import 13thSlip Pay Buffer"."No.");
                if HRMEmployeeD.Find('-') then begin
                  HRMEmployeeD."Employee Type":=HRMEmployeeD."employee type"::Casual;
                  HRMEmployeeD.Status:=HRMEmployeeD.Status::Normal;
                  HRMEmployeeD."Department Code":="Import 13thSlip Pay Buffer"."Department Code";
                  HRMEmployeeD."Main Bank":="Import 13thSlip Pay Buffer"."Bank Code";
                  HRMEmployeeD."Branch Bank":="Import 13thSlip Pay Buffer"."Branch Code";
                  HRMEmployeeD."Bank Account Number":="Import 13thSlip Pay Buffer"."A/C No.";
                  HRMEmployeeD."First Name":="Import 13thSlip Pay Buffer"."F. Name";
                  HRMEmployeeD."Middle Name":="Import 13thSlip Pay Buffer"."M. Name";
                  HRMEmployeeD."Last Name":="Import 13thSlip Pay Buffer"."L. Name";
                  HRMEmployeeD."Daily Rate":="Import 13thSlip Pay Buffer"."Daily Rate";
                  HRMEmployeeD."Posting Group":='13thSlip';
                  HRMEmployeeD.Modify;
                  end else begin
                  HRMEmployeeD.Init;
                  HRMEmployeeD."No.":="Import 13thSlip Pay Buffer"."No.";
                  HRMEmployeeD."Employee Type":=HRMEmployeeD."employee type"::Casual;
                  HRMEmployeeD.Status:=HRMEmployeeD.Status::Normal;
                  HRMEmployeeD."Department Code":="Import 13thSlip Pay Buffer"."Department Code";
                  HRMEmployeeD."Main Bank":="Import 13thSlip Pay Buffer"."Bank Code";
                  HRMEmployeeD."Branch Bank":="Import 13thSlip Pay Buffer"."Branch Code";
                  HRMEmployeeD."Bank Account Number":="Import 13thSlip Pay Buffer"."A/C No.";
                  HRMEmployeeD."First Name":="Import 13thSlip Pay Buffer"."F. Name";
                  HRMEmployeeD."Middle Name":="Import 13thSlip Pay Buffer"."M. Name";
                  HRMEmployeeD."Last Name":="Import 13thSlip Pay Buffer"."L. Name";
                  HRMEmployeeD."Daily Rate":="Import 13thSlip Pay Buffer"."Daily Rate";
                  HRMEmployeeD."Posting Group":='13thSlip';
                  HRMEmployeeD.Insert;
                    end;

                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.","Import 13thSlip Pay Buffer"."No.");
                if HRMEmployeeC.Find('-') then begin
                  HRMEmployeeC."Employee Type":= HRMEmployeeC."employee type"::Casuals;
                  HRMEmployeeC.Status:=HRMEmployeeC.Status::Active;
                  HRMEmployeeC."Department Code":="Import 13thSlip Pay Buffer"."Department Code";
                  HRMEmployeeC."Main Bank":="Import 13thSlip Pay Buffer"."Bank Code";
                  HRMEmployeeC."Branch Bank":="Import 13thSlip Pay Buffer"."Branch Code";
                  HRMEmployeeC."Bank Account Number":="Import 13thSlip Pay Buffer"."A/C No.";
                  HRMEmployeeC."First Name":="Import 13thSlip Pay Buffer"."F. Name";
                  HRMEmployeeC."Middle Name":="Import 13thSlip Pay Buffer"."M. Name";
                  HRMEmployeeC."Last Name":="Import 13thSlip Pay Buffer"."L. Name";
                //  HRMEmployeeC."Daily Rate":="Import 13thSlip Pay Buffer"."Daily Rate";
                  HRMEmployeeC.Modify;
                  end else begin
                    HRMEmployeeC.Init;
                  HRMEmployeeC."No.":="Import 13thSlip Pay Buffer"."No.";
                  HRMEmployeeC."Employee Type":=HRMEmployeeC."employee type"::Casuals;
                  HRMEmployeeC.Status:=HRMEmployeeC.Status::Active;
                  HRMEmployeeC."Department Code":="Import 13thSlip Pay Buffer"."Department Code";
                  HRMEmployeeC."Main Bank":="Import 13thSlip Pay Buffer"."Bank Code";
                  HRMEmployeeC."Branch Bank":="Import 13thSlip Pay Buffer"."Branch Code";
                  HRMEmployeeC."Bank Account Number":="Import 13thSlip Pay Buffer"."A/C No.";
                  HRMEmployeeC."First Name":="Import 13thSlip Pay Buffer"."F. Name";
                  HRMEmployeeC."Middle Name":="Import 13thSlip Pay Buffer"."M. Name";
                  HRMEmployeeC."Last Name":="Import 13thSlip Pay Buffer"."L. Name";
                  //HRMEmployeeC."Daily Rate":="Import 13thSlip Pay Buffer"."Daily Rate";
                  HRMEmployeeC.Insert;
                    end;

                PRL13thSlipPayrollPeriods.Reset;
                PRL13thSlipPayrollPeriods.SetRange("Period Month","Import 13thSlip Pay Buffer"."Period Month");
                PRL13thSlipPayrollPeriods.SetRange("Period Year","Import 13thSlip Pay Buffer"."Period Year");
                PRL13thSlipPayrollPeriods.SetRange("Current Instalment","Import 13thSlip Pay Buffer".Instalment);
                if PRL13thSlipPayrollPeriods.Find('-') then begin
                  end else Error('Period missing');

                PRLEmployeeDaysWorked.Reset;
                PRLEmployeeDaysWorked.SetRange("Employee Code","Import 13thSlip Pay Buffer"."No.");
                PRLEmployeeDaysWorked.SetRange("Payroll Period",PRL13thSlipPayrollPeriods."Date Openned");
                PRLEmployeeDaysWorked.SetRange("Current Instalment",PRL13thSlipPayrollPeriods."Current Instalment");
                if PRLEmployeeDaysWorked.Find('-') then begin
                  PRLEmployeeDaysWorked."Days Worked":="Import 13thSlip Pay Buffer".Days;
                PRLEmployeeDaysWorked."Daily Rate":="Import 13thSlip Pay Buffer"."Daily Rate";
                PRLEmployeeDaysWorked.Modify;
                  end else begin
                  PRLEmployeeDaysWorked.Init;
                  PRLEmployeeDaysWorked."F.  Name":="Import 13thSlip Pay Buffer"."F. Name"+' '+"Import 13thSlip Pay Buffer"."M. Name"+' '+"Import 13thSlip Pay Buffer"."L. Name";
                  PRLEmployeeDaysWorked."Employee Code":="Import 13thSlip Pay Buffer"."No.";
                  PRLEmployeeDaysWorked."Payroll Period":=PRL13thSlipPayrollPeriods."Date Openned";
                  PRLEmployeeDaysWorked."Current Instalment":=PRL13thSlipPayrollPeriods."Current Instalment";
                  PRLEmployeeDaysWorked."Days Worked":="Import 13thSlip Pay Buffer".Days;
                  PRLEmployeeDaysWorked."Daily Rate":="Import 13thSlip Pay Buffer"."Daily Rate";
                  PRLEmployeeDaysWorked."Period Month":="Import 13thSlip Pay Buffer"."Period Month";
                  PRLEmployeeDaysWorked."Period Year":="Import 13thSlip Pay Buffer"."Period Year";
                  PRLEmployeeDaysWorked.Insert;
                    end;
            end;
        }
        dataitem(UnknownTable99202;UnknownTable99202)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PRLTransCodesTransactions.Reset;
                PRLTransCodesTransactions.SetRange("Transaction Code","13thSlip Transactions Import"."Trans. Code");
                if PRLTransCodesTransactions.Find('-') then begin
                  end;

                PRL13thSlipPayrollPeriods.Reset;
                PRL13thSlipPayrollPeriods.SetRange("Period Month","13thSlip Transactions Import"."Period Month");
                PRL13thSlipPayrollPeriods.SetRange("Period Year","13thSlip Transactions Import"."Period Year");
                PRL13thSlipPayrollPeriods.SetRange("Current Instalment","13thSlip Transactions Import".Instalment);
                if PRL13thSlipPayrollPeriods.Find('-') then begin
                  end else Error('Period missing');

                PRL13thSlipEmpTransactions.Reset;
                PRL13thSlipEmpTransactions.SetRange("Employee Code","13thSlip Transactions Import"."Emp. No.");
                PRL13thSlipEmpTransactions.SetRange("Current Instalment","13thSlip Transactions Import".Instalment);
                PRL13thSlipEmpTransactions.SetRange("Transaction Code","13thSlip Transactions Import"."Trans. Code");
                PRL13thSlipEmpTransactions.SetRange("Payroll Period",PRL13thSlipPayrollPeriods."Date Openned");
                if PRL13thSlipEmpTransactions.Find('-') then begin
                PRL13thSlipEmpTransactions.Amount:="13thSlip Transactions Import".Amount;
                PRL13thSlipEmpTransactions."Transaction Name":=PRLTransCodesTransactions."Transaction Name";
                PRL13thSlipEmpTransactions."Transaction Type":=PRLTransCodesTransactions."Transaction Type";
                PRL13thSlipEmpTransactions."Current Instalment":="13thSlip Transactions Import".Instalment;
                PRL13thSlipEmpTransactions."Recurance Index":=99;
                PRL13thSlipEmpTransactions.Modify;
                end else begin
                PRL13thSlipEmpTransactions.Init;
                PRL13thSlipEmpTransactions."Employee Code":="13thSlip Transactions Import"."Emp. No.";
                PRL13thSlipEmpTransactions."Transaction Code":="13thSlip Transactions Import"."Trans. Code";
                PRL13thSlipEmpTransactions."Period Month":="13thSlip Transactions Import"."Period Month";
                PRL13thSlipEmpTransactions."Period Year":="13thSlip Transactions Import"."Period Year";
                PRL13thSlipEmpTransactions."Payroll Period":=PRL13thSlipPayrollPeriods."Date Openned";
                PRL13thSlipEmpTransactions."Current Instalment":="13thSlip Transactions Import".Instalment;;
                PRL13thSlipEmpTransactions."Transaction Name":=PRLTransCodesTransactions."Transaction Name";
                PRL13thSlipEmpTransactions.Amount:="13thSlip Transactions Import".Amount;
                PRL13thSlipEmpTransactions."Recurance Index":=99;
                PRL13thSlipEmpTransactions.Insert;
                 end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PRL13thSlipEmpTransactions: Record UnknownRecord99251;
        HRMEmployeeD: Record UnknownRecord61118;
        HRMEmployeeC: Record UnknownRecord61188;
        PRL13thSlipPayrollPeriods: Record UnknownRecord99250;
        PRLTransCodesTransactions: Record UnknownRecord61082;
        PRLEmployeeDaysWorked: Record UnknownRecord99200;
}

