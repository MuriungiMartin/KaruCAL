#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51322 "Students Balance By prog"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Students Balance By prog.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") order(ascending) where("Customer Type"=const(Student),"New Stud"=const(false));
            RequestFilterFields = "Student Programme","No.";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Progname;Progname)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer__Debit_Amount_;"Debit Amount")
            {
            }
            column(Customer__Credit_Amount_;"Credit Amount")
            {
            }
            column(Customer__Student_Balance_;Balance)
            {
            }
            column(Num;Num)
            {
            }
            column(Customer__Student_Balance__Control1102760000;Balance)
            {
            }
            column(Customer__Credit_Amount__Control1102760007;"Credit Amount")
            {
            }
            column(Customer__Debit_Amount__Control1102760008;"Debit Amount")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(Customer__Debit_Amount_Caption;FieldCaption("Debit Amount"))
            {
            }
            column(Customer__Credit_Amount_Caption;FieldCaption("Credit Amount"))
            {
            }
            column(Customer__Student_Balance_Caption;FieldCaption(Balance))
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(Customer_Current_Programme;"Current Programme")
            {
            }

            trigger OnAfterGetRecord()
            begin
                 /*
                   Prog.RESET;
                  Prog.SETFILTER(Prog.Code,Customer.GETFILTER(Customer."Student Programme"));
                  IF Prog.FIND('-') THEN
                  Progname:=Prog.Description;
                
                
                  Customer."New Stud":=true;
                  Customer.modify;
                  */
                  Num:=Num+1;

            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Current Programme");
                Progname:=Customer.GetFilter(Customer."Student Programme");
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

    trigger OnPreReport()
    begin
         /*
         cust.reset;
         cust.setfilter(Cust."Customer Type",'%1',Cust."Customer Type"::student);
        // cust.setfilter(Cust."Student Programme",'%1',Customer.getfilter(Customer."Programme Filter"));
         if cust.find('-') then begin
         repeat
         Cust."Current Programme":=Cust."Student Programme";
         cust.modify;
         until cust.next=0;
         end;
        */

    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        Progname: Code[100];
        Num: Integer;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        EmptyStringCaptionLbl: label '#';
        TotalsCaptionLbl: label 'Totals';
}

