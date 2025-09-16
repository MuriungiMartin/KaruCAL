#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69038 "HRM-Emp. Bulance Buff"
{
    PageType = List;
    SourceTable = UnknownTable61753;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Name";"Transaction Name")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Fail Reason";"Fail Reason")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(imp)
            {
                ApplicationArea = Basic;
                Caption = 'Import Data';

                trigger OnAction()
                begin
                        if Confirm('Import Balances?',true)=false then exit;
                        Xmlport.Run(52017815,false,true);
                end;
            }
            action(proc)
            {
                ApplicationArea = Basic;
                Caption = 'Process Data';

                trigger OnAction()
                begin
                       peri.Reset;
                       peri.SetRange(peri.Closed,false);
                       peri.SetFilter(peri."Period Name",'<>%1','');
                       if peri.Find('-') then begin
                       // Delete Transactions
                      // emptrans.RESET;
                      // emptrans.SETRANGE(emptrans."Payroll Period",peri."Date Opened");
                      // emptrans.SETFILTER(emptrans.Balance,'=%1',0);
                     //  IF emptrans.FIND('-') THEN BEGIN
                     //    emptrans.DELETEALL;
                     //  END;
                    
                        empbuff.Reset;
                        empbuff.SetRange(empbuff.Posted,false);
                        if empbuff.Find('-') then begin
                          repeat
                          begin
                          if emps.Get(empbuff."Employee No.") then begin
                          salaryCard.Reset;
                          salaryCard.SetRange(salaryCard."Employee Code",empbuff."Employee No.");
                          if not salaryCard.Find('-') then begin
                          salaryCard.Init;
                          salaryCard."Employee Code":=emps."No.";
                          salaryCard.Insert;
                          end;
                          salaryCard.Reset;
                          salaryCard.SetRange(salaryCard."Employee Code",empbuff."Employee No.");
                          if salaryCard.Find('-') then begin
                          // Employee Exists
                          if empbuff."Transaction Name"='PAYE' then begin
                            salaryCard."Pays PAYE":=true;
                            salaryCard.Modify;
                           empbuff."Fail Reason":='';
                            empbuff.Modify;
                          end else if empbuff."Transaction Name"='N.S.S.F' then begin
                            salaryCard."Pays NSSF":=true;
                            salaryCard.Modify;
                           empbuff."Fail Reason":='';
                            empbuff.Modify;
                          end else if empbuff."Transaction Name"='NHIF' then begin
                            salaryCard."Pays NHIF":=true;
                            salaryCard.Modify;
                           empbuff."Fail Reason":='';
                            empbuff.Modify;
                          end else if empbuff."Transaction Name"='BASIC SALARY' then begin
                            salaryCard."Basic Pay":=empbuff.Amount;
                            salaryCard.Modify;
                           empbuff."Fail Reason":='';
                            empbuff.Modify;
                          end else begin
                           transcodes.Reset;
                           transcodes.SetRange(transcodes."Transaction Name",empbuff."Transaction Name");
                           if transcodes.Find('-') then begin
                           emptrans.Reset;
                           emptrans.SetRange(emptrans."Employee Code",emps."No.");
                           emptrans.SetRange(emptrans."Transaction Code",transcodes."Transaction Code");
                           emptrans.SetRange(emptrans."Payroll Period",peri."Date Opened");
                           if emptrans.Find('-') then begin // Update
                            emptrans.Balance:=empbuff.Amount+emptrans.Amount;
                             emptrans.Modify;
                    
                             empbuff.Posted:=true;
                           empbuff."Fail Reason":='';
                           empbuff."Transaction Type":=empbuff."transaction type"::Update;
                            empbuff.Modify;
                           end else begin // Insert
                            emptrans.Init;
                            emptrans."Employee Code":=emps."No.";
                            emptrans."Transaction Code":=transcodes."Transaction Code";
                            emptrans."Period Month":=peri."Period Month";
                            emptrans."Period Year":=peri."Period Year";
                            emptrans."Payroll Period":=peri."Date Opened";
                            emptrans."Transaction Name":=transcodes."Transaction Name";
                            emptrans.Balance:=empbuff.Amount+emptrans.Amount;
                             emptrans.Insert;
                             empbuff.Posted:=true;
                           empbuff."Fail Reason":='';
                           empbuff."Transaction Type":=empbuff."transaction type"::Update;
                            empbuff.Modify;
                          end;
                          empbuff."Transaction Code":=transcodes."Transaction Code";
                          empbuff.Modify;
                           end else begin
                           empbuff."Fail Reason":='Transaction Code';
                            empbuff.Modify;
                           end;
                           end;
                           end;
                          end else begin
                           empbuff."Fail Reason":='Employee';
                            empbuff.Modify;
                    
                          end;
                          end;
                          until empbuff.Next =0;
                        end;
                       end;
                       /*
                    
                        empbuff.RESET;
                       // empbuff.SETRANGE(empbuff.Posted,TRUE);
                        IF empbuff.FIND('-') THEN BEGIN
                          REPEAT
                          BEGIN
                         IF empbuff.Posted=TRUE THEN   empbuff.Posted:=FALSE;
                        //
                        empbuff."Transaction Type":=empbuff."Transaction Type"::" ";
                            empbuff.MODIFY;
                             IF empbuff."Transaction Name"='PENSION TODATE' THEN BEGIN
                            //  empbuff."Transaction Name":='PENSION';
                              empbuff.RENAME(empbuff."Employee No.",'PENSION',empbuff.Amount);
                             END;
                          END;
                          UNTIL empbuff.NEXT=0;
                          END;  */

                end;
            }
        }
    }

    var
        emps: Record UnknownRecord61118;
        empbuff: Record UnknownRecord61753;
        emptrans: Record UnknownRecord61091;
        peri: Record UnknownRecord61081;
        transcodes: Record UnknownRecord61082;
        salaryCard: Record UnknownRecord61105;
}

