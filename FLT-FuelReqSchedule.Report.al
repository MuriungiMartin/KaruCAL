#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 55517 "FLT-Fuel Req Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLT-Fuel Req Schedule.rdlc';

    dataset
    {
        dataitem(fheader;UnknownTable55500)
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
            column(ReqNo_fheader;fheader."Req. No.")
            {
            }
            column(ReqDate_fheader;fheader."Req. Date")
            {
            }
            column(ReqTime_fheader;fheader."Req. Time")
            {
            }
            column(Purpose_fheader;fheader.Purpose)
            {
            }
            column(EmpNo_fheader;fheader."Emp. No.")
            {
            }
            column(RequestedBy_fheader;fheader."Requested By")
            {
            }
            column(DescriptionNotes_fheader;fheader."Description/Notes")
            {
            }
            column(Department_fheader;fheader.Department)
            {
            }
            column(DepartmentName_fheader;fheader."Department Name")
            {
            }
            column(Status_fheader;fheader.Status)
            {
            }
            column(NoofVehicles_fheader;fheader."No of Vehicles")
            {
            }
            column(RequisitionValue_fheader;fheader."Requisition Value")
            {
            }
            column(Supplier_fheader;fheader.Supplier)
            {
            }
            column(SupplierName_fheader;fheader."Supplier Name")
            {
            }
            dataitem(fdetaills;UnknownTable55501)
            {
                DataItemLink = "Req. No."=field("Req. No.");
                column(ReportForNavId_1000000015; 1000000015)
                {
                }
                column(ReqNo_fdetaills;fdetaills."Req. No.")
                {
                }
                column(VehicleRegistration_fdetaills;fdetaills."Vehicle Registration")
                {
                }
                column(VehicleDetails_fdetaills;fdetaills."Vehicle Details")
                {
                }
                column(FuelType_fdetaills;fdetaills."Fuel Type")
                {
                }
                column(CCRating_fdetaills;fdetaills."CC Rating")
                {
                }
                column(FuellingDate_fdetaills;fdetaills."Fuelling Date")
                {
                }
                column(FuellingTime_fdetaills;fdetaills."Fuelling Time")
                {
                }
                column(FuellingDoneByEmployee_fdetaills;fdetaills."Fuelling Done By (Employee)")
                {
                }
                column(UnitPrice_fdetaills;fdetaills."Unit Price")
                {
                }
                column(QuantityLitres_fdetaills;fdetaills."Quantity (Litres)")
                {
                }
                column(Amount_fdetaills;fdetaills.Amount)
                {
                }
                column(UserID_fdetaills;fdetaills."User ID")
                {
                }
                column(Supplier_fdetaills;fdetaills.Supplier)
                {
                }
                column(SupplierName_fdetaills;fdetaills."Supplier Name")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
                CompanyInformation.CalcFields(Picture);
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
        CompanyInformation: Record "Company Information";
}

