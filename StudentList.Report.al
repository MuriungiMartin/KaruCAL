#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51476 "Student List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student List.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Type"=const(Student));
            RequestFilterFields = "No.",Gender,"Student Programme";
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
            column(UserFilters;UserFilters)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer__Date_Registered_;"Date Registered")
            {
            }
            column(Customer_Status;Status)
            {
            }
            column(Customer__Balance__LCY__;"Balance (LCY)")
            {
            }
            column(Hesabu;Hesabu)
            {
            }
            column(Customer__Balance__LCY___Control1000000010;"Balance (LCY)")
            {
            }
            column(Student_ListCaption;Student_ListCaptionLbl)
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
            column(Customer__Date_Registered_Caption;FieldCaption("Date Registered"))
            {
            }
            column(Customer_StatusCaption;FieldCaption(Status))
            {
            }
            column(Customer__Balance__LCY__Caption;FieldCaption("Balance (LCY)"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                  CReg.Reset;
                  CReg.SetFilter(CReg."Student No.",Customer."No.");
                  CReg.SetFilter(CReg.Programme,GetFilter(Customer."Programme Filter"));
                  CReg.SetFilter(CReg."Settlement Type",GetFilter(Customer."Settlement Type Filter"));
                  if CReg.Find('-') then begin
                     // CurrReport.SKIP()
                  end else begin
                     CurrReport.Skip()
                  end;
            end;

            trigger OnPreDataItem()
            begin
                  UserFilters:=GetFilter(Customer."No.")+' '+Customer.GetFilter(Customer.Status)+' '+Customer.GetFilter(Customer.
                "Programme Filter")
                  +' '+Customer.GetFilter(Customer."Settlement Type Filter");
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
        UserFilters: Text[200];
        CReg: Record UnknownRecord61532;
        Student_ListCaptionLbl: label 'Student List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

