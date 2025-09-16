#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51727 "Hostel Clearance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Clearance.rdlc';

    dataset
    {
        dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
        {
            DataItemTableView = sorting("Line No",Student) where(Cleared=const(false),"Space No"=filter(<>''));
            RequestFilterFields = Semester,"Hostel No","Room No","Space No";
            column(ReportForNavId_4756; 4756)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Students_Hostel_Rooms__Space_No_;"Space No")
            {
            }
            column(Students_Hostel_Rooms__Room_No_;"Room No")
            {
            }
            column(Students_Hostel_Rooms__Hostel_No_;"Hostel No")
            {
            }
            column(Students_Hostel_Rooms__Accomodation_Fee_;"Accomodation Fee")
            {
            }
            column(Students_Hostel_Rooms__Allocation_Date_;"Allocation Date")
            {
            }
            column(Students_Hostel_Rooms__Clearance_Date_;"Clearance Date")
            {
            }
            column(Students_Hostel_Rooms_Student;Student)
            {
            }
            column(Students_Hostel_Rooms_Billed;Billed)
            {
            }
            column(Students_Hostel_Rooms_Semester;Semester)
            {
            }
            column(Students_Hostel_RoomsCaption;Students_Hostel_RoomsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Students_Hostel_Rooms__Space_No_Caption;FieldCaption("Space No"))
            {
            }
            column(Students_Hostel_Rooms__Room_No_Caption;FieldCaption("Room No"))
            {
            }
            column(Students_Hostel_Rooms__Hostel_No_Caption;FieldCaption("Hostel No"))
            {
            }
            column(Students_Hostel_Rooms__Accomodation_Fee_Caption;FieldCaption("Accomodation Fee"))
            {
            }
            column(Students_Hostel_Rooms__Allocation_Date_Caption;FieldCaption("Allocation Date"))
            {
            }
            column(Students_Hostel_Rooms__Clearance_Date_Caption;FieldCaption("Clearance Date"))
            {
            }
            column(Students_Hostel_Rooms_StudentCaption;FieldCaption(Student))
            {
            }
            column(Students_Hostel_Rooms_BilledCaption;FieldCaption(Billed))
            {
            }
            column(Students_Hostel_Rooms_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Students_Hostel_Rooms_Line_No;"Line No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                    Rooms.Reset;
                    Rooms.SetRange(Rooms."Hostel No","ACA-Students Hostel Rooms"."Hostel No") ;
                    Rooms.SetRange(Rooms."Room No","ACA-Students Hostel Rooms"."Room No");
                    Rooms.SetRange(Rooms."Space No","ACA-Students Hostel Rooms"."Space No");
                    if Rooms.Find('-') then begin
                      Rooms.Status:=Rooms.Status::Vaccant;
                      Rooms.Modify;
                      "ACA-Students Hostel Rooms".Cleared:=true;
                      "ACA-Students Hostel Rooms"."Clearance Date":=Today;
                      "ACA-Students Hostel Rooms"."Hostel Assigned":=false;
                      "ACA-Students Hostel Rooms"."Eviction Code":='CLEARED BY '+UserId;
                     // StudentHostel."Billed Date":=TODAY;
                      "ACA-Students Hostel Rooms".Modify;
                    end;
            end;

            trigger OnPreDataItem()
            begin
                if Confirm('Do you really want to run the hostels clearance') then begin
                end else begin
                CurrReport.Break;
                end;
                if Confirm('Please note that this will clear students from their current rooms, Do you still want to continue?') then begin
                end else begin
                CurrReport.Break;
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

    var
        Rooms: Record "ACA-Hostel Ledger";
        Students_Hostel_RoomsCaptionLbl: label 'Students Hostel Rooms';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

