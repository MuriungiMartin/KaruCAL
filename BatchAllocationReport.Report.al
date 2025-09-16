#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77340 "Batch Allocation Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Batch Allocation Report.rdlc';

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
            dataitem(RoomAlloc;"ACA-Batch Room Alloc. Details")
            {
                DataItemLink = "Hostel Block"=field("Asset No");
                RequestFilterFields = "Academic Year","Hostel Block";
                column(ReportForNavId_22; 22)
                {
                }
                column(rmCode;RoomAlloc."Room No")
                {
                }
                column(stdNo;RoomAlloc."Student No.")
                {
                }
                column(stdName;RoomAlloc."Student Name")
                {
                }
                column(stdaddress;Address)
                {
                }
                column(stdphone;RoomAlloc."Phone Number")
                {
                }
                column(host;RoomAlloc."Hostel Block")
                {
                }
                column(rm;RoomAlloc."Room No")
                {
                }
                column(spc;RoomAlloc."Room Space")
                {
                }
                column(years;RoomAlloc."Academic Year")
                {
                }
                column(sems;'Semester 1 2023/2024')
                {
                }

                trigger OnAfterGetRecord()
                begin
                      Clear(Address);
                      Clear(City);
                      Clear(Customer);
                      Customer.Reset;
                      Customer.SetRange("No.",RoomAlloc."Student No.");
                      if Customer.Find('-') then begin
                       Address := Customer.Address+' '+Customer."Address 2"+' '+Customer.City;
                       end else begin
                         Clear(KUCCPSImports);
                         KUCCPSImports.Reset;
                         KUCCPSImports.SetRange(Admin,RoomAlloc."Student No.");
                         if KUCCPSImports.Find('-') then begin
                       Address := KUCCPSImports.Box+' '+KUCCPSImports.Codes+' '+KUCCPSImports.Town;
                           end;
                         end;
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
        KUCCPSImports: Record UnknownRecord70082;
        Address: Text[150];
        City: Code[20];
}

