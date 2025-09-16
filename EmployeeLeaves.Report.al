#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51330 "Employee Leaves"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Leaves.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "On Leave","No.","Employee Type","Employee Category";
            column(ReportForNavId_3372; 3372)
            {
            }
            column(compName;CompanyInformation.Name)
            {
            }
            column(addresses;CompanyInformation.Address+','+CompanyInformation."Address 2")
            {
            }
            column(phones;CompanyInformation."Phone No."+'/'+CompanyInformation."Phone No. 2")
            {
            }
            column(emails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(pics;CompanyInformation.Picture)
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
            column(Names;"HRM-Employee C"."First Name"+' '+"HRM-Employee C"."Middle Name"+' '+"HRM-Employee C"."Last Name")
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(StartDate;"HRM-Employee C"."Current Leave Start")
            {
            }
            column(Enddates;"HRM-Employee C"."Current Leave End")
            {
            }
            column(LeaveType;"HRM-Employee C"."Current Leave Type")
            {
            }
            column(currdays;"HRM-Employee C"."Current Leave Applied Days")
            {
            }
            column(ReportFilters;ReportFilters)
            {
            }
            column(seq;seq)
            {
            }
            column(LeaveBal;"HRM-Employee C"."Leave Balance")
            {
            }
            column(Grade;"HRM-Employee C".Grade)
            {
            }
            column(Category;"HRM-Employee C"."Library Category")
            {
            }
            column(Status;"HRM-Employee C".Status)
            {
            }

            trigger OnAfterGetRecord()
            begin
                seq:=seq+1;
            end;

            trigger OnPreDataItem()
            begin
                Clear(ReportFilters);
                ReportFilters:="HRM-Employee C".GetFilters;
                Clear(seq);
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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        Report.Run(77711,false,false);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CompanyInformation: Record "Company Information";
        ReportFilters: Text[1024];
        seq: Integer;
}

