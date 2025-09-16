#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51373 "Resident Room Agreement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Resident Room Agreement.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Programme_Customer;Customer.Programme)
            {
            }
            column(No_Customer;Customer."No.")
            {
            }
            column(Name_Customer;Customer.Name)
            {
            }
            column(PhoneNo_Customer;Customer."Phone No.")
            {
            }
            column(GlobalDimension1Code_Customer;Customer."Global Dimension 1 Code")
            {
            }
            column(EMail_Customer;Customer."E-Mail")
            {
            }
            column(NamesofNOK;NamesofNOK)
            {
            }
            column(Relationship;Relationship)
            {
            }
            column(NOKPhone;NOKPhone)
            {
            }
            dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
            {
                DataItemLink = Student=field("No.");
                DataItemTableView = where(Cleared=const(false));
                column(ReportForNavId_1000000339; 1000000339)
                {
                }
                column(LineNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Line No")
                {
                }
                column(SpaceNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Space No")
                {
                }
                column(RoomNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Room No")
                {
                }
                column(HostelNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Hostel No")
                {
                }
                column(AccomodationFee_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Accomodation Fee")
                {
                }
                column(AllocationDate_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Allocation Date")
                {
                }
                column(ClearanceDate_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Clearance Date")
                {
                }
                column(Charges_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Charges)
                {
                }
                column(Student_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Student)
                {
                }
                column(Billed_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Billed)
                {
                }
                column(BilledDate_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Billed Date")
                {
                }
                column(Semester_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Semester)
                {
                }
                column(Cleared_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Cleared)
                {
                }
                column(OverPaid_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Over Paid")
                {
                }
                column(OverPaidAmt_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Over Paid Amt")
                {
                }
                column(EvictionCode_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Eviction Code")
                {
                }
                column(Gender_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Gender)
                {
                }
                column(HostelAssigned_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Hostel Assigned")
                {
                }
                column(HostelName_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Hostel Name")
                {
                }
                column(StudentName_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Student Name")
                {
                }
                column(AcademicYear_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Academic Year")
                {
                }
                column(Session_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Session)
                {
                }
                column(Allocated_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Allocated)
                {
                }
                column(Select_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Select)
                {
                }
                column(Balance_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Balance)
                {
                }
                column(TransfertoHostelNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Transfer to Hostel No")
                {
                }
                column(TransfertoRoomNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Transfer to Room No")
                {
                }
                column(TransfertoSpaceNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Transfer to Space No")
                {
                }
                column(Transfered_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Transfered)
                {
                }
                column(Reversed_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Reversed)
                {
                }
                column(Switched_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Switched)
                {
                }
                column(SwitchedfromHostelNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Switched from Hostel No")
                {
                }
                column(SwitchedfromRoomNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Switched from Room No")
                {
                }
                column(SwitchedfromSpaceNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Switched from Space No")
                {
                }
                column(SwitchedtoHostelNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Switched to Hostel No")
                {
                }
                column(SwitchedtoRoomNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Switched to Room No")
                {
                }
                column(SwitchedtoSpaceNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Switched to Space No")
                {
                }
                column(TransfedfromHostelNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Transfed from Hostel No")
                {
                }
                column(TransfedfromRoomNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Transfed from Room No")
                {
                }
                column(TransfedfromSpaceNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Transfed from Space No")
                {
                }
                column(Status_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Status)
                {
                }
                column(InvoicePrinted_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Invoice Printed")
                {
                }
                column(InvoicePrintedBy_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Invoice Printed By")
                {
                }
                column(SwithedBy_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Swithed By")
                {
                }
                column(TransferedBy_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Transfered By")
                {
                }
                column(ReverseAllocatedBy_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Reverse Allocated By")
                {
                }
                column(KeyAllocated_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Key Allocated")
                {
                }
                column(KeyNo_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Key No")
                {
                }
                column(AllocatedBy_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Allocated By")
                {
                }
                column(Timeallocated_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Time allocated")
                {
                }
                column(TimeReversed_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Time Reversed")
                {
                }
                column(TimeTransfered_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Time Transfered")
                {
                }
                column(TimeSwithed_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Time Swithed")
                {
                }
                column(DateReversed_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Date Reversed")
                {
                }
                column(DateTransfered_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Date Transfered")
                {
                }
                column(DateSwitched_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Date Switched")
                {
                }
                column(KeyAllocatedBy_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Key Allocated By")
                {
                }
                column(KeyAllocatedTime_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Key Allocated Time")
                {
                }
                column(KeyAllocatedDate_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Key Allocated Date")
                {
                }
                column(ReversedBy_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Reversed By")
                {
                }
                column(SwitchedBy_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Switched By")
                {
                }
                column(StartDate_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Start Date")
                {
                }
                column(EndDate_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."End Date")
                {
                }
                column(SettlementType_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Settlement Type")
                {
                }
                column(CampusCode_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Campus Code")
                {
                }
                column(Valid_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Valid)
                {
                }
                column(Reasonfortransfer_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Reason for transfer")
                {
                }
                column(ReasonforSwitch_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Reason for Switch")
                {
                }
                column(StudentExists_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Student Exists")
                {
                }
                column(StudentCounts_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Student Counts")
                {
                }
                column(RegisteredForCurrentAcademi_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms"."Registered For Current Academi")
                {
                }
                column(Imported_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Imported)
                {
                }
                column(Invoiced_ACAStudentsHostelRooms;"ACA-Students Hostel Rooms".Invoiced)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Kuccps.Reset;
                Kuccps.SetRange(Kuccps.Admin,Customer."No.");
                if Kuccps.FindFirst then begin
                  NamesofNOK:=Kuccps."Emergency Name1";
                  NOKPhone:=Kuccps."Emergency Phone No1";
                  Relationship:=Kuccps."Emergency Relationship1";
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
        NamesofNOK: Text;
        Relationship: Text;
        NOKPhone: Text;
        ProgrammeName: Text;
        SchoolName: Text;
        Kuccps: Record UnknownRecord70082;
        Kin: Record UnknownRecord61528;
}

