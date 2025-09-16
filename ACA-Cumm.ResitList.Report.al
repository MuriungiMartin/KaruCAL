#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66658 "ACA-Cumm. Resit List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Cumm. Resit List.rdlc';

    dataset
    {
        dataitem(GradStuds;UnknownTable66653)
        {
            RequestFilterFields = "School Code",Programme,"Academic Year";
            column(ReportForNavId_10; 10)
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(Phone;CompanyInformation."Phone No."+' '+CompanyInformation."Phone No. 2")
            {
            }
            column(Email;CompanyInformation."E-Mail")
            {
            }
            column(HomePage;CompanyInformation."Home Page")
            {
            }
            dataitem(CummResits;UnknownTable66657)
            {
                DataItemLink = "Student Number"=field("Student Number");
                column(ReportForNavId_1; 1)
                {
                }
                column(StudNo;CummResits."Student Number")
                {
                }
                column(Names;CummResits."Student Name")
                {
                }
                column(UnitCode;CummResits."Unit Code")
                {
                }
                column(UnitDesc;CummResits."Unit Description")
                {
                }
                column(Prog;CummResits.Programme)
                {
                }
                column(SchCode;CummResits."School Code")
                {
                }
                column(SchName;CummResits."School Name")
                {
                }
                column(Grade;CummResits.Grade)
                {
                }
            }
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

    var
        CompanyInformation: Record "Company Information";
}

