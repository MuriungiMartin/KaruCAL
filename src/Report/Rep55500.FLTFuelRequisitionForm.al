#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 55500 "FLT-Fuel Requisition Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLT-Fuel Requisition Form.rdlc';

    dataset
    {
        dataitem(UnknownTable55500;UnknownTable55500)
        {
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
            column(ReqNo;"FLT-Fuel Req. Header"."Req. No.")
            {
            }
            column(DateTime;CreateDatetime("FLT-Fuel Req. Header"."Req. Date","FLT-Fuel Req. Header"."Req. Time"))
            {
            }
            column(Purpose;"FLT-Fuel Req. Header".Purpose)
            {
            }
            column(EmployeeNo;"FLT-Fuel Req. Header"."Emp. No.")
            {
            }
            column(RequestedBy;"FLT-Fuel Req. Header"."Requested By")
            {
            }
            column(Notes;"FLT-Fuel Req. Header"."Description/Notes")
            {
            }
            column(DepartmentCode;"FLT-Fuel Req. Header".Department)
            {
            }
            column(Status;"FLT-Fuel Req. Header".Status)
            {
            }
            column(DepatmentName;"FLT-Fuel Req. Header"."Department Name")
            {
            }
            column(NoofVehicles;"FLT-Fuel Req. Header"."No of Vehicles")
            {
            }
            column(ReqValue;"FLT-Fuel Req. Header"."Requisition Value")
            {
            }
            dataitem(UnknownTable55501;UnknownTable55501)
            {
                DataItemLink = "Req. No."=field("Req. No.");
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(LineNo;"FLT-Fuel Req. Details"."Line No.")
                {
                }
                column(VehicleReg;"FLT-Fuel Req. Details"."Vehicle Registration")
                {
                }
                column(VehicleDet;"FLT-Fuel Req. Details"."Vehicle Details")
                {
                }
                column(FuelType;"FLT-Fuel Req. Details"."Fuel Type")
                {
                }
                column(CCRate;"FLT-Fuel Req. Details"."CC Rating")
                {
                }
                column(FuelDate;"FLT-Fuel Req. Details"."Fuelling Date")
                {
                }
                column(FuelTime;"FLT-Fuel Req. Details"."Fuelling Time")
                {
                }
                column(FuelBy;"FLT-Fuel Req. Details"."Fuelling Done By (Employee)")
                {
                }
                column(UnitPrice;"FLT-Fuel Req. Details"."Unit Price")
                {
                }
                column(QtyLtrs;"FLT-Fuel Req. Details"."Quantity (Litres)")
                {
                }
                column(Amount;"FLT-Fuel Req. Details".Amount)
                {
                }
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
                HRMEmployeeC.SetRange("No.","FLT-Fuel Req. Header"."Emp. No.");
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

