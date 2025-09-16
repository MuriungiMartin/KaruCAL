#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 55513 "FLT-Maintenance Schedule2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLT-Maintenance Schedule2.rdlc';

    dataset
    {
        dataitem(MaintHeader;UnknownTable55517)
        {
            RequestFilterFields = "Req. Date","Service Done By (Employee)";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address;CompanyInformation.Address+' ,'+CompanyInformation."Address 2"+' ,'+CompanyInformation.City)
            {
            }
            column(conts;CompanyInformation."Phone No."+' '+CompanyInformation."Phone No. 2")
            {
            }
            column(mails;CompanyInformation."E-Mail"+' '+CompanyInformation."Home Page")
            {
            }
            column(Logo;CompanyInformation.Picture)
            {
            }
            column(EmpName;HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name")
            {
            }
            column(ReqNo;MaintHeader."Req. No.")
            {
            }
            column(ReqDate;MaintHeader."Req. Date")
            {
            }
            column(Reqtime;MaintHeader."Req. Time")
            {
            }
            column(MaintType;MaintHeader."Maintenance Type")
            {
            }
            column(EmpNo;MaintHeader."Emp. No.")
            {
            }
            column(ReqByUser;MaintHeader."Requested By")
            {
            }
            column(Notes;MaintHeader."Work Performed & Notes")
            {
            }
            column(DepartmentCode;MaintHeader.Department)
            {
            }
            column(Status;MaintHeader.Status)
            {
            }
            column(MaintPeriod;MaintHeader."Maintenance Period")
            {
            }
            column(RegNo;MaintHeader."Vehicle Registration")
            {
            }
            column(VehicleDet;MaintHeader."Vehicle Details")
            {
            }
            column(FuelType;MaintHeader."Fuel Type")
            {
            }
            column(VehicleCC;MaintHeader."CC Rating")
            {
            }
            column(ServicedBy;MaintHeader."Service Done By (Employee)")
            {
            }
            column(ServeAmount;MaintHeader.Amount)
            {
            }
            column(VehicleateofServe;MaintHeader."Date of Service")
            {
            }
            column(VehicleMake;MaintHeader."Vihicle Make")
            {
            }
            column(VehicleModel;MaintHeader."Vehicle Model")
            {
            }
            column(DeptName;MaintHeader."Department Name")
            {
            }
            column(Perioddesc;MaintHeader."Period Description")
            {
            }
            column(DateofService;MaintHeader."Date of Service")
            {
            }
            column(Mileageatservice;MaintHeader."Milleage of Service")
            {
            }
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("Req. No.");
                DataItemTableView = where(Status=filter(Approved),"Document Type"=filter(Fuel));
                column(ReportForNavId_1000000002; 1000000002)
                {
                }
                column(ApproverId;"Approval Entry"."Approver ID")
                {
                }
                dataitem(usersetup;"User Setup")
                {
                    DataItemLink = "User ID"=field("Approver ID");
                    column(ReportForNavId_1000000030; 1000000030)
                    {
                    }
                    column(DateApproved;"Approval Entry"."Last Date-Time Modified")
                    {
                    }
                    column(ApproverSignature;usersetup."User Signature")
                    {
                    }
                    column(ApproverName;HRMEmployeeC2."First Name"+''+HRMEmployeeC2."Middle Name"+' '+HRMEmployeeC2."Last Name")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        HRMEmployeeC2.Reset;
                        HRMEmployeeC2.SetRange("No.",usersetup."Staff No");
                        if HRMEmployeeC2.Find('-') then begin

                          end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.",MaintHeader."Emp. No.");
                if HRMEmployeeC.Find('-') then begin
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

    trigger OnPreReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        FLTVehicleHeader: Record UnknownRecord61816;
        HRMEmployeeC: Record UnknownRecord61188;
        HRMEmployeeC2: Record UnknownRecord61188;
}

