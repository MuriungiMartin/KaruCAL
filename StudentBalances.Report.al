#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51481 "Student Balances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Balances.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("Current Programme") order(ascending) where("Customer Type"=const(Student),"Current Programme"=filter(<>''),"In Current Sem"=filter(>0));
            RequestFilterFields = "No.","Date Filter","Balance (LCY)","Debit Amount (LCY)","Credit Amount (LCY)","Current Programme";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer__Debit_Amount__LCY__;"Debit Amount (LCY)")
            {
            }
            column(Customer__Credit_Amount__LCY__;"Credit Amount (LCY)")
            {
            }
            column(Customer__Balance__LCY__;"Balance (LCY)")
            {
            }
            column(Hesabu;Hesabu)
            {
            }
            column(totalc;totalc)
            {
            }
            column(Totald;Totald)
            {
            }
            column(totalb;totalb)
            {
            }
            column(ClassCode;Customer."Class Code")
            {
            }
            column(CurrentProgramme_Customer;Customer."Current Programme")
            {
            }
            column(BalPerc;BalPerc)
            {
            }
            column(ProgDesc;ProgDesc)
            {
            }
            column(Logo;CompInf.Picture)
            {
            }
            column(CompName;CompInf.Name)
            {
            }
            column(CurrentSettlementType_Customer;Customer."Current Settlement Type")
            {
            }
            column(CurrentStage_Customer;Customer."Current Stage")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Prog.Get(Customer."Current Programme") then
                ProgDesc:=Prog.Description;

                Totald:=Totald+Customer."Debit Amount (LCY)";
                totalc:=totalc+Customer."Credit Amount (LCY)";
                totalb:=totalb+Customer."Balance (LCY)";
                Hesabu:=Hesabu+1;

                BalPerc:=0;
                if (Customer."Debit Amount (LCY)"<>0) and (Customer."Credit Amount (LCY)"<>0) then
                 BalPerc:=Customer."Credit Amount (LCY)"/Customer."Debit Amount (LCY)"*100;
            end;

            trigger OnPreDataItem()
            begin
                Creg.Reset;
                Creg.SetRange(Creg."Student No.",Customer."No.");
                Creg.SetRange(Creg.Reversed,false);
                if Creg.Find('-') then begin
                if Cust.Get(Creg."Student No.") then begin
                Cust."Current Programme":=Creg.Programme;
                Cust."Current Settlement Type":=Creg."Settlement Type";
                Cust."Current Stage":=Creg.Stage;
                Cust.Modify;
                end;
                end;

                CompInf.Get;
                //CompInf.CALCFIELDS(CompInf.Picture);
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
        Hesabu: Integer;
        totalc: Decimal;
        Totald: Decimal;
        totalb: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CustomerCaptionLbl: label 'Customer';
        StageCaptionLbl: label 'Stage';
        BalPerc: Decimal;
        Creg: Record UnknownRecord61532;
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        ProgDesc: Text[150];
        CompInf: Record "Company Information";
}

