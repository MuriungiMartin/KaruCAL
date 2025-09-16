#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51137 "Hostel Allo. Per Room/Block"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Allo. Per RoomBlock.rdlc';

    dataset
    {
        dataitem("ACA-Hostel Card";"ACA-Hostel Card")
        {
            DataItemTableView = sorting("Asset No") order(ascending);
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
            dataitem("ACA-Hostel Block Rooms";"ACA-Hostel Block Rooms")
            {
                DataItemLink = "Hostel Code"=field("Asset No");
                DataItemTableView = sorting("Hostel Code","Room Code") order(ascending) where("Occupied Spaces"=filter(>0));
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Hostel Code","Room Code";
                column(ReportForNavId_22; 22)
                {
                }
                column(rmCode;"ACA-Hostel Block Rooms"."Room Code")
                {
                }
                dataitem(RoomSpaces;"ACA-Hostel Ledger")
                {
                    DataItemLink = "Hostel No"=field("Hostel Code"),"Room No"=field("Room Code");
                    DataItemTableView = sorting("Room No",Status) order(ascending) where("Student No"=filter(<>''));
                    RequestFilterFields = "Hostel No","Room No","Space No";
                    column(ReportForNavId_24; 24)
                    {
                    }
                    column(stdNo;RoomSpaces."Student No")
                    {
                    }
                    column(stdName;RoomSpaces."Student Name")
                    {
                    }
                    column(stdaddress;RoomSpaces.Address+', '+RoomSpaces.City)
                    {
                    }
                    column(stdphone;RoomSpaces.Phone)
                    {
                    }
                    column(host;RoomSpaces."Hostel No")
                    {
                    }
                    column(rm;RoomSpaces."Room No")
                    {
                    }
                    column(spc;RoomSpaces."Space No")
                    {
                    }
                    column(years;RoomSpaces."Academic Year")
                    {
                    }
                    column(sems;RoomSpaces.Semester)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                          if Customer.Get(RoomSpaces."Student No") then begin
                            Customer.CalcFields(Customer."Hostel No.",Customer."Room Code",Customer."Space Booked");
                          end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if ViewMisplaced then begin
                            RoomSpaces.SetFilter("Student Name",'%1','');
                          end;
                    end;
                }
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
            area(content)
            {
                field(ViewMisplaced;ViewMisplaced)
                {
                    ApplicationArea = Basic;
                    Caption = 'View Misplaced Allocations';
                }
            }
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
        ViewMisplaced: Boolean;
}

