#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78095 "Student Process Nfm"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "No.","Date Filter";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudNo;Customer."No.")
            {
            }
            column(StudName;Customer.Name)
            {
            }
            column(campus;Customer."Global Dimension 1 Code")
            {
            }
            column(ProgName;Progs.Description)
            {
            }
            column(Progs;ACACourseRegistration.Programme)
            {
            }
            column(Semesters;ACACourseRegistration.Semester)
            {
            }
            column(Stages;ACACourseRegistration.Stage)
            {
            }
            column(Settlement;ACACourseRegistration."Settlement Type")
            {
            }
            column(AcadYear;ACACourseRegistration."Academic Year")
            {
            }
            column(compName;CompanyInformation.Name)
            {
            }
            column(address;CompanyInformation.Address+','+CompanyInformation."Address 2")
            {
            }
            column(phones;CompanyInformation."Phone No."+'/'+CompanyInformation."Phone No. 2")
            {
            }
            column(pics;CompanyInformation.Picture)
            {
            }
            column(mails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(Balance_NFMStatementEntry;Fbalance)
            {
            }
            dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No."=field("No.");
                DataItemTableView = sorting("Customer No.","Posting Date") order(ascending) where("Entry Type"=filter("Initial Entry"));
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(pDate;CustLedgerEntry."Posting Date")
                {
                }
                column(DocNo;CustLedgerEntry."Document No.")
                {
                }
                column(Desc;CopyStr(CustLedgerEntry.Description,1,35)+CustLedgerEntry."External Document No.")
                {
                }
                column(Amount;TotalAmount)
                {
                }
                column(DebitAm;DebitAmount)
                {
                }
                column(CreditAm;CreditAmount)
                {
                }
                column(Semester;Semester)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Gl: Code[25];
                begin
                    //runningBal:=runningBal+"Detailed Cust. Ledg. Entry"."Debit Amount"-"Detailed Cust. Ledg. Entry"."Credit Amount";
                    ignore:=false;
                    Semester:='';
                    if "Detailed Cust. Ledg. Entry".Amount<>0 then begin
                      GlEntry.Reset;
                      GlEntry.SetRange("Document No.","Detailed Cust. Ledg. Entry"."Document No.");
                      GlEntry.SetFilter("G/L Account No.",'%1|%2','30008','30004','60086');
                      if GlEntry.FindFirst then CurrReport.Skip;
                      end;



                    CustLedgerEntry.Reset;
                    CustLedgerEntry.SetRange(CustLedgerEntry."Entry No.","Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
                    if CustLedgerEntry.Find('-') then begin
                      if (CustLedgerEntry.Reversed or CustLedgerEntry."Skip Nfm") then CurrReport.Skip;
                      end;
                      Gl:='';
                    if "Detailed Cust. Ledg. Entry"."Debit Amount"<>0 then begin
                      GlEntry.Reset;
                      GlEntry.SetRange("Document No.","Detailed Cust. Ledg. Entry"."Document No.");
                      GlEntry.SetFilter("G/L Account No.",'%1|%2|%3|%4|%5|%6|%7|%8','60055','60090','60092','60096','60098','60130','60075','60086');
                      if GlEntry.FindFirst then begin
                            ignore:=true;
                        Gl:=GlEntry."G/L Account No.";
                        end;
                      end;
                      if "Detailed Cust. Ledg. Entry"."Document No." in ['KUCCPS','CUE','ID'] then begin

                        ignore:=true;
                        end;
                      DebitAmount:=0;
                      CreditAmount:=0;
                      TotalAmount:=0;
                      HefProcessingFee:=0;
                      DebitAmount:="Detailed Cust. Ledg. Entry".Amount;
                      CreditAmount:="Detailed Cust. Ledg. Entry"."Credit Amount";
                      TotalAmount:="Detailed Cust. Ledg. Entry".Amount;
                          if DebitAmount>0 then begin
                          AbsAmount:=Abs("Detailed Cust. Ledg. Entry".Amount);
                              // MESSAGE('NO. %1 date %2 amt %3',"Detailed Cust. Ledg. Entry"."Customer No.","Detailed Cust. Ledg. Entry"."Posting Date",AbsAmount);

                               StdCharges.Reset;
                                          StdCharges.SetRange("Student No.","Detailed Cust. Ledg. Entry"."Customer No.");
                    //           StdCharges.SETRANGE(Date,"Detailed Cust. Ledg. Entry"."Posting Date");
                               StdCharges.SetRange("Transacton ID","Detailed Cust. Ledg. Entry"."Document No.");
                               if StdCharges.FindFirst then begin
                                   Bandentry.Reset;
                      Bandentry.SetRange("Student No.",Customer."No.");
                      Bandentry.SetRange(Semester,StdCharges.Semester);
                      Bandentry.SetRange(Archived,false);
                      Bandentry.SetCurrentkey("Batch No.");
                      if Bandentry.Find('-') then begin
                        HshldPerc:=Bandentry."HouseHold Percentage";
                        end;
                                 Semester:=StdCharges.Semester;
                                 Sems.Reset;
                                 Sems.SetRange(Sems.Code,Semester);
                                 if Sems.FindFirst then begin
                                   HefProcessingFee:=Sems."HEF Processing Fee";
                                   end;
                                 end else begin
                                   if "Detailed Cust. Ledg. Entry"."Document No."='TUITION' then begin
                                     Semester:='SEM1 24/25';
                                     end;
                                   end;
                                 end;
                            if ("Detailed Cust. Ledg. Entry".Amount=(Bandentry."Programme Cost"/2) ) or (not ignore) then
                        begin
                                         Bandentry.Reset;
                      Bandentry.SetRange("Student No.",Customer."No.");
                      Bandentry.SetRange(Archived,false);
                      Bandentry.SetRange(Semester,Semester);
                      Bandentry.SetCurrentkey("Batch No.");
                      if Bandentry.Find('-') then begin
                        HshldPerc:=Bandentry."HouseHold Percentage";
                        end;
                    //      IF HshldPerc=0 THEN BEGIN
                    //      bands.RESET;
                    //      bands.SETRANGE(bands."Band Code",Bandentry."Band Code");
                    //      bands.SETRANGE("Academic Year",Bandentry."Academic Year");
                    //      IF bands.FINDLAST THEN BEGIN
                    //        HshldPerc:=bands."Household Percentage";
                    //        END;
                    //      END;
                    if (HshldPerc<>0) then begin
                          if DebitAmount> 0 then  begin
                          DebitAmount:=((HshldPerc/100)*DebitAmount);
                            end
                          else DebitAmount:=0;
                          TotalAmount:=(HshldPerc/100)*TotalAmount;
                          end;
                          end;

                    if (DebitAmount>0) or ignore and (Semester='') then begin
                      if ("Detailed Cust. Ledg. Entry"."Document No." in ['KUCCPS','CUE','ID'] ) or ignore then begin
                        CosReg.Reset;
                        CosReg.SetRange("Student No.","Detailed Cust. Ledg. Entry"."Customer No.");
                        CosReg.SetCurrentkey(Semester);
                        if CosReg.FindFirst then begin
                          Semester:=CosReg.Semester;
                          end;
                        end;
                      end;
                      //MESSAGE('added %1 fee %2',ProcessingfeeAdded,HefProcessingFee);
                            if (Lastsemester <> Semester) and (HefProcessingFee<>0) and (Semester <> '') and (not ignore ) then  begin
                              DebitAmount+=HefProcessingFee;
                              TotalAmount+=HefProcessingFee;
                                   //          MESSAGE('procfee %1',HefProcessingFee);
                              ProcessingfeeAdded:=true;
                              Lastsemester:=Semester;
                              end;

                    NfmEntry.Init;
                    NfmEntry."Student No.":="Detailed Cust. Ledg. Entry"."Customer No.";
                    NfmEntry."Entry No":=0;
                    NfmEntry."Credit amount":=CreditAmount;
                    if DebitAmount>0 then
                    NfmEntry."Debit amount":=DebitAmount;
                    if DebitAmount > 0 then  begin
                      TotalAmount:=DebitAmount;
                      NfmEntry.Description:='Student Household Charges for Semester: '+Semester;
                      NfmEntry.Type:=NfmEntry.Type::Debit;
                      if ignore then begin
                          NfmEntry.Description:=CustLedgerEntry.Description;
                          NfmEntry.Type:=NfmEntry.Type::Credit;
                          //message('aye %1',CustLedgerEntry.Description);
                        end;
                      end
                    else if CreditAmount<>0 then begin
                      TotalAmount:=(Abs(CreditAmount))*-1;
                      NfmEntry.Description:=CopyStr(CustLedgerEntry.Description,1,50)+CustLedgerEntry."External Document No.";
                       NfmEntry.Type:=NfmEntry.Type::Credit;
                      end;
                    //  IF Semester='' THEN BEGIN
                    //  NfmEntry.Description:="Detailed Cust. Ledg. Entry"."Document No."+' '+COPYSTR(CustLedgerEntry.Description,1,50)+CustLedgerEntry."External Document No.";
                    //  END;
                    NfmEntry.Semester:=Semester;
                    NfmEntry.Amount:=TotalAmount;
                    NfmEntry.Date:="Detailed Cust. Ledg. Entry"."Posting Date";
                    if NfmEntry.Type=NfmEntry.Type::Debit then begin
                    NfmEntryII.Reset;
                    NfmEntryII.SetRange(NfmEntryII."Student No.","Detailed Cust. Ledg. Entry"."Customer No.");
                    NfmEntryII.SetRange(NfmEntryII.Semester,Semester);
                    NfmEntryII.SetRange(NfmEntryII.Type,NfmEntry.Type::Debit);
                    if NfmEntryII.FindFirst then begin
                      NfmEntryII.Amount+=TotalAmount;
                      NfmEntryII."Credit amount"+=CreditAmount;
                      NfmEntryII."Debit amount"+=DebitAmount;
                      NfmEntryII.Modify();
                      end else
                    NfmEntry.Insert(true);
                    end else
                    NfmEntry.Insert(true);
                    Commit;
                    Customer.CalcFields("Nfm Balance");
                end;
            }
            dataitem("NFM Statement Entry";"NFM Statement Entry")
            {
                CalcFields = Balance;
                DataItemLink = "Student No."=field("No.");
                column(ReportForNavId_1000000025; 1000000025)
                {
                }
                column(EntryNo_NFMStatementEntrys;"NFM Statement Entry"."Entry No")
                {
                }
                column(StudentNo_NFMStatementEntry;"NFM Statement Entry"."Student No.")
                {
                }
                column(Description_NFMStatementEntry;"NFM Statement Entry".Description)
                {
                }
                column(Amount_NFMStatementEntry;"NFM Statement Entry".Amount)
                {
                }
                column(Semester_NFMStatementEntry;"NFM Statement Entry".Semester)
                {
                }
                column(Date_NFMStatementEntry;"NFM Statement Entry".Date)
                {
                }
                column(Debitamount_NFMStatementEntry;"NFM Statement Entry"."Debit amount")
                {
                }
                column(Creditamount_NFMStatementEntry;"NFM Statement Entry"."Credit amount")
                {
                }
                column(runningBal;runningBal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                     TotalAmount:="NFM Statement Entry".Amount;
                      runningBal:=runningBal+TotalAmount;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(runningBal);
                ACACourseRegistration.Reset;
                ACACourseRegistration.SetRange(ACACourseRegistration."Student No.",Customer."No.");
                ACACourseRegistration.SetFilter(ACACourseRegistration.Programme,'<>%1','');
                ACACourseRegistration.SetFilter(ACACourseRegistration.Reversed,'=%1',false);
                ACACourseRegistration.SetFilter(ACACourseRegistration.Transfered,'=%1',false);
                ACACourseRegistration.SetCurrentkey(Stage);
                if ACACourseRegistration.Find('+') then begin
                  Progs.Reset;
                  Progs.SetRange(Code,ACACourseRegistration.Programme);
                  if Progs.Find('-') then begin
                    end;
                  end;

                NfmEntry.Reset;
                NfmEntry.SetRange("Student No.",Customer."No.");
                NfmEntry.DeleteAll();
                ProcessingfeeAdded:=true;
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

    trigger OnInitReport()
    begin
        // CompanyInformation.RESET;
        // IF CompanyInformation.FIND('-') THEN BEGIN
        //  CompanyInformation.CALCFIELDS(Picture);
        //  END;
    end;

    var
        runningBal: Decimal;
        ACACourseRegistration: Record UnknownRecord61532;
        Progs: Record UnknownRecord61511;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CompanyInformation: Record "Company Information";
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        bands: Record "Funding Band Categories";
        Bandentry: Record "Funding Band Entries";
        HshldPerc: Decimal;
        TotalAmount: Decimal;
        GlEntry: Record "G/L Entry";
        NfmEntry: Record "NFM Statement Entry";
        StdCharges: Record UnknownRecord61535;
        ignore: Boolean;
        Semester: Code[25];
        AbsAmount: Decimal;
        NfmEntryII: Record "NFM Statement Entry";
        Balance: Decimal;
        CosReg: Record UnknownRecord61532;
        Fbalance: Decimal;
        HefProcessingFee: Decimal;
        Sems: Record UnknownRecord61692;
        ProcessingfeeAdded: Boolean;
        Lastsemester: Code[25];
}

