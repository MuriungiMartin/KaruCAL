#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51369 "Exam Card Label1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exam Card Label1.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "Programme Filter","Stage Filter","Semester Filter","Balance (LCY)","No.",Status;
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Customer_No_;"No.")
            {
            }
            column(Customer_Programme_Filter;"Programme Filter")
            {
            }
            column(Customer_Stage_Filter;"Stage Filter")
            {
            }
            column(Customer_Semester_Filter;"Semester Filter")
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = "Student No."=field("No."),Programme=field("Programme Filter"),Stage=field("Stage Filter"),Semester=field("Semester Filter");
                DataItemTableView = sorting("Student No.");
                MaxIteration = 1;
                RequestFilterFields = "Student No.";
                column(ReportForNavId_2901; 2901)
                {
                }
                column(Addr_1__1_;Addr[1][1])
                {
                }
                column(Addr_1__2_;Addr[1][2])
                {
                }
                column(Addr_1__3_;Addr[1][3])
                {
                }
                column(Addr_2__1_;Addr[2][1])
                {
                }
                column(Addr_2__2_;Addr[2][2])
                {
                }
                column(Addr_2__3_;Addr[2][3])
                {
                }
                column(Addr_1__4_;Addr[1][4])
                {
                }
                column(Addr_1__4__Control1102760007;Addr[1][4])
                {
                }
                column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Course_Registration_Student_No_;"Student No.")
                {
                }
                column(Course_Registration_Programme;Programme)
                {
                }
                column(Course_Registration_Semester;Semester)
                {
                }
                column(Course_Registration_Register_for;"Register for")
                {
                }
                column(Course_Registration_Stage;Stage)
                {
                }
                column(Course_Registration_Unit;Unit)
                {
                }
                column(Course_Registration_Student_Type;"Student Type")
                {
                }
                column(Course_Registration_Entry_No_;"Entry No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RecordNo := RecordNo + 1;
                    ColumnNo := ColumnNo + 1;
                    
                    /*
                    Cust.RESET;
                    Sname:='';
                    Cust.SETRANGE(Cust."No.","Course Registration"."Student No.");
                    IF Cust.FIND('-') THEN BEGIN
                      Sname:=Cust.Name;
                    END;
                    */
                    progrec.Reset;
                    Programmedesc:='';
                    progrec.SetRange(progrec.Code,"ACA-Course Registration".Programme);
                    if progrec.Find('-') then begin
                      Programmedesc:=progrec.Description;
                    end;
                    
                    
                    "ACA-Course Registration".CalcFields("ACA-Course Registration".Faculty);
                    
                    dimrec.Reset;
                    DimDesc:='';
                    dimrec.SetRange(dimrec.Code,"ACA-Course Registration".Faculty);
                    if dimrec.Find('-') then begin
                      DimDesc:=dimrec.Name;
                    end;
                    
                    
                    Addr[ColumnNo][1] := Format("Student No.");
                    
                    Cust.Reset;
                    Sname:='';
                    Cust.SetRange(Cust."No.","ACA-Course Registration"."Student No.");
                    if Cust.Find('-') then begin
                      Sname:=Cust.Name;
                    end;
                    
                    
                    Addr[ColumnNo][2] := Format(DimDesc);
                    Addr[ColumnNo][3] := Format(Programmedesc);
                    Addr[ColumnNo][4] := Format(Sname);
                    
                    CompressArray(Addr[ColumnNo]);
                    
                    
                    
                    if RecordNo = NoOfRecords then begin
                      for i := ColumnNo + 1 to NoOfColumns do
                        Clear(Addr[i]);
                      ColumnNo := 0;
                    end else begin
                      if ColumnNo = NoOfColumns then
                        ColumnNo := 0;
                    end;

                end;

                trigger OnPreDataItem()
                begin
                    NoOfRecords := Count;
                    NoOfColumns := 2;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Customer.CalcFields(Customer."Student Programme");
                //Customer."Programme Filter"
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
        Addr: array [2,4] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        Sname: Text[150];
        Cust: Record Customer;
        dimrec: Record "Dimension Value";
        DimDesc: Text[150];
        Programmedesc: Text[150];
        progrec: Record UnknownRecord61511;
}

