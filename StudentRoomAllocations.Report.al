#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51001 "Student Room Allocations"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Room Allocations.rdlc';

    dataset
    {
        dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
        {
            RequestFilterFields = "Hostel No","Room No","Space No";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(University;University)
            {
            }
            column(HostAll;HostAll)
            {
            }
            column(studNo_1;studNo[1])
            {
            }
            column(Studname_1;Studname[1])
            {
            }
            column(Gend_1;Gend[1])
            {
            }
            column(hostelName_1;hostelName[1])
            {
            }
            column(RoomNo_1;RoomNo[1])
            {
            }
            column(SpaceNo_1;SpaceNo[1])
            {
            }
            column(studNo_2;studNo[2])
            {
            }
            column(Studname_2;Studname[2])
            {
            }
            column(Gend_2;Gend[2])
            {
            }
            column(hostelName_2;hostelName[2])
            {
            }
            column(RoomNo_2;RoomNo[2])
            {
            }
            column(SpaceNo_2;SpaceNo[2])
            {
            }
            column(studNo_3;studNo[3])
            {
            }
            column(Studname_3;Studname[3])
            {
            }
            column(Gend_3;Gend[3])
            {
            }
            column(hostelName_3;hostelName[3])
            {
            }
            column(RoomNo_3;RoomNo[3])
            {
            }
            column(SpaceNo_3;SpaceNo[3])
            {
            }

            trigger OnAfterGetRecord()
            begin
                    if ((i>3) or (i=0)) then begin
                     Clear(Studname);
                     Clear(studNo);
                     Clear(Gend);
                     Clear(hostelName);
                     Clear(RoomNo);
                     Clear(SpaceNo);

                    Clear(i);
                      i:=1;
                      end;

                   HOST.Reset;
                   HOST.SetRange(HOST."Asset No","ACA-Students Hostel Rooms"."Hostel No");
                   if HOST.Find('-') then begin
                   end;

                    studNo[i]:="ACA-Students Hostel Rooms".Student;
                    Studname[i]:="ACA-Students Hostel Rooms"."Student Name";
                    Gend[i]:=Format("ACA-Students Hostel Rooms".Gender);
                    hostelName[i]:=HOST.Description;//"Room Allocation Buffer"."Hostel No";
                    RoomNo[i]:="ACA-Students Hostel Rooms"."Room No";
                    SpaceNo[i]:="ACA-Students Hostel Rooms"."Space No";

                    studNo[i]:='NO: '+studNo[i];
                    Studname[i]:='NAME: '+Studname[i];
                    Gend[i]:='GENDER: '+Gend[i];
                    hostelName[i]:='HOSTEL: '+hostelName[i];
                    RoomNo[i]:='ROOM: '+RoomNo[i];
                    SpaceNo[i]:='SPACE: '+SpaceNo[i];

                    i:=i+1;
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
             Clear(Studname);
             Clear(studNo);
             Clear(Gend);
             Clear(hostelName);
             Clear(RoomNo);
             Clear(SpaceNo);
            // CLEAR(i);
           // i:=1;
    end;

    var
        Studname: array [3] of Text[150];
        studNo: array [3] of Code[50];
        Gend: array [3] of Code[50];
        hostelName: array [3] of Code[100];
        RoomNo: array [3] of Code[50];
        SpaceNo: array [3] of Code[50];
        University: label 'KARATINA UNIVERSITY';
        HostAll: label 'Student Hostel Allocation';
        i: Integer;
        HOST: Record "ACA-Hostel Card";
}

