#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 61833 "Hostel Status Summary Graph"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Status Summary Graph.rdlc';

    dataset
    {
        dataitem("ACA-Hostel Card";"ACA-Hostel Card")
        {
            CalcFields = "Vaccant Spaces","Room Spaces","Occupied Spaces","Fully Occupied","Partially Occupied";
            RequestFilterFields = "Asset No";
            column(ReportForNavId_1; 1)
            {
            }
            column(address;info.Address)
            {
            }
            column(Phone;info."Phone No.")
            {
            }
            column(pics;info.Picture)
            {
            }
            column(No;"ACA-Hostel Card"."Asset No")
            {
            }
            column(Desc;"ACA-Hostel Card".Description)
            {
            }
            column(Vaccant;"ACA-Hostel Card".Vaccant)
            {
            }
            column(fullyOccupied;"ACA-Hostel Card"."Fully Occupied")
            {
            }
            column(partiallyOccupied;"ACA-Hostel Card"."Partially Occupied")
            {
            }
            column(Blacklisted;"ACA-Hostel Card".Blacklisted)
            {
            }
            column(totRooms;totRooms)
            {
            }
            column(vspaces;"ACA-Hostel Card"."Vaccant Spaces")
            {
            }
            column(OccupiedSpaces;"ACA-Hostel Card"."Occupied Spaces")
            {
            }
            column(TotalSpaces;"ACA-Hostel Card"."Room Spaces")
            {
            }

            trigger OnAfterGetRecord()
            begin
                     Clear(totRooms);
                     totRooms:="ACA-Hostel Card".Vaccant+"ACA-Hostel Card"."Fully Occupied"+"ACA-Hostel Card".Blacklisted+"ACA-Hostel Card"."Partially Occupied";
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
         info.Reset;
         if info.Find('-') then info.CalcFields(Picture)
    end;

    var
        info: Record "Company Information";
        totRooms: Integer;
}

