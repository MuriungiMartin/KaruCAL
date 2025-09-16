#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51791 "Hostel Allo. Per Room (Det.)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Allo. Per Room (Det.).rdlc';

    dataset
    {
        dataitem(info;"Company Information")
        {
            CalcFields = Picture;
            DataItemTableView = where(Name=filter(<>''));
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1; 1)
            {
            }
            column(CName;info.Name)
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
            dataitem(RoomSpaces;"ACA-Hostel Ledger")
            {
                DataItemTableView = where("Student No"=filter(<>''));
                RequestFilterFields = "Hostel No","Room No","Space No";
                column(ReportForNavId_24; 24)
                {
                }
                column(rmCode;RoomSpaces."Room No")
                {
                }
                column(No;ACAHostelCard."Asset No")
                {
                }
                column(Desc;ACAHostelCard.Description)
                {
                }
                column(Vaccant;ACAHostelCard.Vaccant)
                {
                }
                column(fullyOccupied;ACAHostelCard."Fully Occupied")
                {
                }
                column(partiallyOccupied;ACAHostelCard."Partially Occupied")
                {
                }
                column(Blacklisted;ACAHostelCard.Blacklisted)
                {
                }
                column(totRooms;totRooms)
                {
                }
                column(stdNo;RoomSpaces."Student No")
                {
                }
                column(stdName;RoomSpaces."Student Name")
                {
                }
                column(stdaddress;Address)
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
                column(StartDate;creg."Registration Date")
                {
                }
                column(enddate;acadYShcedule."End Date")
                {
                }
                column(AllocatedBy;RoomSpaces."User ID")
                {
                }
                column(AllocDate;roomall."Allocation Date")
                {
                }

                trigger OnAfterGetRecord()
                begin
                        ACAHostelCard.Reset;
                        ACAHostelCard.SetRange("Asset No",RoomSpaces."Hostel No");
                        if ACAHostelCard.Find('-') then begin
                          Clear(totRooms);
                         totRooms:=ACAHostelCard.Vaccant+ACAHostelCard."Fully Occupied"+ACAHostelCard.Blacklisted+ACAHostelCard."Partially Occupied";
                     end;
                     Customer.Reset;
                     Customer.SetRange("No.",RoomSpaces."Student No");
                       if Customer.Find('-') then begin
                       Clear(Phones);
                       Clear(Address);
                       Address:=Customer.Address+' '+Customer."Address 2";
                       Phones:=Customer."Phone No.";
                       end else begin
                       Clear(Phones);
                       Clear(Address);
                         end;
                        creg.Reset;
                        creg.SetRange(creg."Student No.",RoomSpaces."Student No");
                        creg.SetRange(creg.Semester,RoomSpaces.Semester);
                        if creg.Find('-') then begin
                        sems.Reset;
                        sems.SetRange(sems."Current Semester",true);
                        if sems.Find('-') then begin
                          acadYShcedule.Reset;
                          acadYShcedule.SetRange(acadYShcedule.Semester,sems.Code);
                          if acadYShcedule.Find('-') then begin

                          end;
                        end;
                        end;
                        roomall.Reset;
                        roomall.SetRange(roomall.Student,RoomSpaces."Student No");
                        roomall.SetRange(roomall."Space No",RoomSpaces."Space No");
                        roomall.SetRange(roomall."Room No",RoomSpaces."Room No");
                        roomall.SetRange(roomall."Hostel No",RoomSpaces."Hostel No");
                        roomall.SetRange(roomall.Semester,RoomSpaces.Semester);
                        if roomall.Find('-') then begin
                        end;

                    CalcFields(RoomSpaces."User ID");
                end;
            }
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

    var
        totRooms: Integer;
        creg: Record UnknownRecord61532;
        sems: Record UnknownRecord61692;
        acadYShcedule: Record UnknownRecord61654;
        roomall: Record "ACA-Students Hostel Rooms";
        ACAHostelCard: Record "ACA-Hostel Card";
        Customer: Record Customer;
        Address: Text[100];
        Phones: Text[100];
}

