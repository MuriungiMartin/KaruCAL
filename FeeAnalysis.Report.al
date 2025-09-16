#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51576 "Fee Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fee Analysis.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Type"=const(Student));
            RequestFilterFields = "No.","Date Filter","Debit Amount (LCY)";
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
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(CourseR;CourseR)
            {
            }
            column(Customer__Payments_By_;"Payments By")
            {
            }
            column(Customer__Debit_Amount__LCY__;"Debit Amount (LCY)")
            {
            }
            column(Customer__Debit_Amount__LCY___Control1102760016;"Debit Amount (LCY)")
            {
            }
            column(Fee_AnalysisCaption;Fee_AnalysisCaptionLbl)
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
            column(CategoryCaption;CategoryCaptionLbl)
            {
            }
            column(Customer__Payments_By_Caption;FieldCaption("Payments By"))
            {
            }
            column(Customer__Debit_Amount__LCY__Caption;FieldCaption("Debit Amount (LCY)"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.",Customer."No.");
                if CourseReg.Find('-') then


                CourseR:=CourseReg."Settlement Type";
                if CourseReg."Settlement Type" = 'FULL PAYMENT' then
                CourseR:='JAB';
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
        CourseReg: Record UnknownRecord61532;
        CourseR: Code[20];
        Fee_AnalysisCaptionLbl: label 'Fee Analysis';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CategoryCaptionLbl: label 'Category';
}

