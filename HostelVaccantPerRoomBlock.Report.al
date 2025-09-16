#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51321 "Hostel Vaccant Per Room/Block"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Vaccant Per RoomBlock.rdlc';

    dataset
    {
        dataitem("ACA-Hostel Card";"ACA-Hostel Card")
        {
            PrintOnlyIfDetail = true;
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
            column(HostCode;"ACA-Hostel Card"."Asset No")
            {
            }
            column(HostelName;"ACA-Hostel Card".Description)
            {
            }
            dataitem("ACA-Hostel Block Rooms";"ACA-Hostel Block Rooms")
            {
                DataItemLink = "Hostel Code"=field("Asset No");
                DataItemTableView = where("Occupied Spaces"=filter(>0));
                PrintOnlyIfDetail = false;
                RequestFilterFields = "Hostel Code","Room Code","Bed Spaces",Status;
                column(ReportForNavId_22; 22)
                {
                }
                column(rmCode;"ACA-Hostel Block Rooms"."Room Code")
                {
                }
                column(TotSpaces;"ACA-Hostel Block Rooms"."Total Spaces")
                {
                }
                column(OccupiedSpaces;"ACA-Hostel Block Rooms"."Occupied Spaces")
                {
                }
                column(VacantSpaces;"ACA-Hostel Block Rooms"."Vacant Spaces")
                {
                }

                trigger OnAfterGetRecord()
                begin
                               CalcFields("ACA-Hostel Block Rooms"."Total Spaces","ACA-Hostel Block Rooms"."Bed Spaces","ACA-Hostel Block Rooms"."Occupied Spaces","ACA-Hostel Block Rooms"."Vacant Spaces");
                end;
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
        Customer: Record Customer;
}

