#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51136 "Hostel Allocations Per Block"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Allocations Per Block.rdlc';

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
            dataitem(RoomSpaces;"ACA-Hostel Ledger")
            {
                DataItemLink = "Hostel No"=field("Asset No");
                DataItemTableView = where("Student No"=filter(<>''));
                RequestFilterFields = "Hostel No","Room No","Space No";
                column(ReportForNavId_23; 23)
                {
                }
                column(stdNo;RoomSpaces."Student No")
                {
                }
                column(stdName;RoomSpaces."Student Name")
                {
                }
                column(stdaddress;Addresses)
                {
                }
                column(stdphone;Phones)
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
                column(seq;seq)
                {
                }
                column(RegDate;ACAStudentsHostelRooms."Allocation Date")
                {
                }
                column(ReservID;ACAStudentsHostelRooms."Allocated By")
                {
                }
                column(Semester;ACAStudentsHostelRooms.Semester)
                {
                }

                trigger OnAfterGetRecord()
                begin
                     Customer.Reset;
                     Customer.SetRange("No.",RoomSpaces."Student No");
                      if Customer.Find('-') then begin
                        Clear(Addresses);
                        Clear(Phones);
                        Addresses:=Customer.Address+' '+Customer."Address 2"+' '+Customer.City;
                        Phones:=Customer."Phone No.";
                       // Customer.CALCFIELDS(Customer."Hostel No.",Customer."Room Code",Customer."Space Booked");
                      end else begin
                        Clear(Addresses);
                        Clear(Phones);
                        end;
                      seq:=seq+1;

                    ACAStudentsHostelRooms.Reset;
                    ACAStudentsHostelRooms.SetRange(ACAStudentsHostelRooms.Student,RoomSpaces."Student No");
                    ACAStudentsHostelRooms.SetRange(ACAStudentsHostelRooms."Hostel No",RoomSpaces."Hostel No");
                    ACAStudentsHostelRooms.SetRange(ACAStudentsHostelRooms."Space No",RoomSpaces."Space No");
                    ACAStudentsHostelRooms.SetRange(ACAStudentsHostelRooms."Room No",RoomSpaces."Room No");
                    ACAStudentsHostelRooms.SetRange(ACAStudentsHostelRooms.Semester,RoomSpaces.Semester);
                    if ACAStudentsHostelRooms.Find('-') then begin
                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                     Clear(totRooms);
                     totRooms:="ACA-Hostel Card".Vaccant+"ACA-Hostel Card"."Fully Occupied"+"ACA-Hostel Card".Blacklisted+"ACA-Hostel Card"."Partially Occupied";


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

    trigger OnPreReport()
    begin
         info.Reset;
         if info.Find('-') then info.CalcFields(Picture);
         Clear(seq);
    end;

    var
        info: Record "Company Information";
        totRooms: Integer;
        seq: Integer;
        Customer: Record Customer;
        ACAStudentsHostelRooms: Record "ACA-Students Hostel Rooms";
        Phones: Text[150];
        Addresses: Text[150];
}

