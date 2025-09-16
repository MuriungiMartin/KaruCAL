#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65250 "HelpDesk Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HelpDesk Register.rdlc';

    dataset
    {
        dataitem(UnknownTable78012;UnknownTable78012)
        {
            RequestFilterFields = "Request Date","Response Date","Assigned Personel","Sender ID";
            RequestFilterHeading = 'Please Filter your report';
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column("Code";"HelpDesk Header".Code)
            {
            }
            column(Sender;"HelpDesk Header"."Sender ID")
            {
            }
            column(Question;"HelpDesk Header".Question)
            {
            }
            column(Response;"HelpDesk Header".Response)
            {
            }
            column(Status;"HelpDesk Header".Status)
            {
            }
            column(RequestDate;"HelpDesk Header"."Request Date")
            {
            }
            column(ResponseDate;"HelpDesk Header"."Response Date")
            {
            }
            column(ResponseBy;"HelpDesk Header".RespondedBy)
            {
            }
            column(Category;"HelpDesk Header".Category)
            {
            }
            column(Department;"HelpDesk Header".Department)
            {
            }
            column(Name;"HelpDesk Header".Name)
            {
            }
            column(AssignedPersonCode;"HelpDesk Header"."Assigned Personel")
            {
            }
            column(AssignedPersonName;"HelpDesk Header"."Assigned Personel Name")
            {
            }
            column(ExpectedResTime;"HelpDesk Header"."Expected Resolution Time")
            {
            }
            column(ExpectedResDate;"HelpDesk Header"."Expected Resolution Date")
            {
            }
            column(AssignedUserId;"HelpDesk Header"."Assigned User ID")
            {
            }
            column(Comments;"HelpDesk Header".Comments)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(Phone;CompanyInformation."Phone No."+','+CompanyInformation."Phone No. 2")
            {
            }
            column(Mails;CompanyInformation."Home Page"+'/'+CompanyInformation."E-Mail")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
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
        if CompanyInformation.Find('-') then begin
            CompanyInformation.CalcFields(Picture);
          end;
    end;

    var
        CompanyInformation: Record "Company Information";
}

