#!/usr/bin/perl
use FindBin;
use List::Util 1.33 'any';
use constant false => 0;
use constant true  => 1;

#Menú
sub menu{
    print "********************LISTADO********************\n";
    print "* 1. Listar Presupuesto Sancionado.           *\n";
    print "* 2. Listar Presupuesto Ejecutado.            *\n";
    print "* 3. Listar Control Presupuesto Ejecutado.    *\n";
    print "* 4. Ayuda del comando.                       *\n";
    print "* 5. Salir.                                   *\n";
    print "***********************************************\n";
    
    my $opcion = <STDIN>;
    chomp($opcion);
    
    if($opcion eq "1"){
        &listadoPresupuestoSancionado;
        &menu;
    }
    if($opcion eq "2"){
        &listadoPresupuestoEjecutado;
        &menu;
    }
    if($opcion eq "3"){
        &listadoControlPresupuestoEjecutado;
        &menu;
    }
    if($opcion eq "4"){
        &ayudaComando;
        &menu;
    }
    if($opcion eq "5"){
        exit();
    }
    else{
        print "No existe esa opción.\n";
        &menu;
    }
    
}

#Listado de presupuesto sancionado
sub listadoPresupuestoSancionado{
    print "************************Presupuesto Sancionado************************\n";
    print "* 1. Listar ordenado por trimestre y luego por Código de Centro.     *\n";
    print "* 2. Listar ordenado por Código de Centro y luego por trimestre.     *\n";
    print "* 3. Volver.                                                         *\n";
    print "**********************************************************************\n";
    
    my $opcion = <STDIN>;
    chomp($opcion);
    
    if($opcion eq "1"){
        &ordenTC;
        &listadoPresupuestoSancionado;
    }
    if($opcion eq "2"){
        &ordenCT;
        &listadoPresupuestoSancionado;
    }
    if($opcion eq "3"){
        &menu;
    } else{
        print "No existe esa opción.\n";
        &listadoPresupuestoSancionado;
    }
}

#Listado de presupuesto ejecutado
sub listadoPresupuestoEjecutado{
    print "************************Presupuesto Ejecutado*************************\n";
    print "******************************Filtrado********************************\n";
    print "* 1. Filtrar una sola provincia.                                     *\n";
    print "* 2. Filtrar varias provincias.                                      *\n";
    print "* 3. Filtrar todas las Provincias.                                   *\n";
    print "* 4. Volver.                                                         *\n";
    print "**********************************************************************\n";
    
    my $opcion = <STDIN>;
    chomp($opcion);
    
    if($opcion eq "1"){
        &filtroProvincia;
        &listadoPresupuestoEjecutado;
    }
    if($opcion eq "2"){
        &filtroProvincias;
        &listadoPresupuestoEjecutado;
    }
    if($opcion eq "3"){
        &sinFiltro;
        &listadoPresupuestoEjecutado;
    }
    if($opcion eq "4"){
        &menu;
    } else{
        print "No existe esa opción.\n";
        &listadoPresupuestoEjecutado;
    }
}

#Listado del control presupuesto ejecutado
sub listadoControlPresupuestoEjecutado{
    print "********************Control Presupuesto Ejecutado*********************\n";
    print "**************************Filtrado Trimeste***************************\n";
    print "* 1. Filtrar un solo trimestre.                                      *\n";
    print "* 2. Filtrar varios trimestres.                                      *\n";
    print "* 3. Filtrar todos los trimestres.                                   *\n";
    print "* 4. Volver.                                                         *\n";
    print "**********************************************************************\n";
    local @Centros_filtrados;
    local @Trimestres_filtrados;
    my $opcion = <STDIN>;
    chomp($opcion);
    
    if($opcion eq "1"){
		print "Escriba el numero de trimestre que quiere filtrar\n";
		my $aux = <STDIN>;
   		chomp($aux);
		@Trimestres_filtrados[0] = $aux;
    }elsif($opcion eq "2"){
		print "Escriba los numeros de trimestres que quiere filtrar separados por un ;\n";
		my $aux = <STDIN>;
   		chomp($aux);
		@Trimestres_filtrados = split(";",$aux);
    }elsif($opcion eq "3"){
		@Trimestres_filtrados = split (";","1;2;3;4")
    }elsif($opcion eq "4"){
        &menu;
    }else{
        print "No existe esa opción.\n";
        &listadoControlPresupuestoEjecutado;
    }
    print "***************************Filtrado Centro****************************\n";
    print "* 1. Filtrar un centro.                                              *\n";
    print "* 2. Filtrar varios centros.                                         *\n";
    print "* 3. Filtrar un rango de centros.                                    *\n";
    print "* 4. Filtrar todas los centros.                                      *\n";
    print "* 5. Volver.                                                         *\n";
    print "**********************************************************************\n";
    my $opcion = <STDIN>;
    chomp($opcion);
    
    if($opcion eq "1"){
		print "Escriba el codigo del centro que quiere filtrar\n";
		my $aux = <STDIN>;
   		chomp($aux);
		@Centros_filtrados[0] = $aux;
    }elsif($opcion eq "2"){
		print "Escriba los codigos de los centros que quiere filtrar separados por ;\n";
		my $aux = <STDIN>;
   		chomp($aux);
		@Centros_filtrados = split(";",$aux);
    }elsif($opcion eq "3"){
		&abrirCentros;
		print "Escriba el rango de codigos de los centros que quiere filtrar seguido de un *\n";
		my $aux = <STDIN>;
   		chomp($aux);
		$aux=substr($aux, 0, -1);
		my @arr = keys %centros;
        my $bool;
		foreach $centro (@arr){
            $bool=true;
            if(index($centro,$aux) eq -1||length($centro)<length($aux)){
                $bool =false;
            } 
            if(length($centro)<length($aux)){
                $bool =false;
            } 
			if($bool){
				push @Centros_filtrados, $centro;		
			}		
		}	
    }elsif($opcion eq "4"){
		&abrirCentros;
		@Centros_filtrados = keys %centros;
    }elsif($opcion eq "5"){
        &menu;
    }else{
        print "No existe esa opción.\n";
        &listadoControlPresupuestoEjecutado;
    }
	&generarListadoControlEjecutado; 
	&listadoControlPresupuestoEjecutado;     
}

sub ayudaComando{
    print "COMANDO LISTEP\n";
    print "--------------\n";
    print "\n";
    print "Con este comando se crean listados/reportes. Podés elegir 3 tipos diferentes:\n";
    print "-Presupuesto Sancionado.\n";
    print "-Presupuesto Ejecutado.\n";
    print "-Control del Presupuesto Ejecutado.\n";
    print "\n";
    print "Dependiendo del listado que elijas, el programa te pedirá que ingreses ciertos parámetros.\n";
    print "El listado/reporte será mostrado en la pantalla y, según corresponda, se generará un archivo CSV con el mismo dentro de la carpeta rep.\n";
    print "\n";
}

#Presupuesto sancionado ordenado por trimestre y luego por Código de Centro
sub ordenTC{
    &opcListado;
    &abrirCentros;
    open(SANCIONADO,"<$FindBin::Bin/../mae/sancionado-$anio.csv") || die "ERROR: No se pudo abrir el archivo sancionado-$anio.csv\n";
    
    my $totalTrimestre = 0;
    my $totalAnual = 0;
    <SANCIONADO>;
    chomp(my $linea = <SANCIONADO>);
    @reg = split(";",$linea);
    my $trimestreAnterior = @reg[1];
    my $centro = %centros{@reg[0]};
    
    my $totalCentro = &sumarDecimales;
    
    $totalTrimestre += $totalCentro;
    print "Año presupuestario $anio";
    printf("%45s\n",'Total sancionado');
    print "--------------------------------------------------------------------";
    print "\n";
    printf("%-47s",$centro);
    printf("%21.2f\n",$totalCentro);
    


    my $i=0;
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        while(-e "$FindBin::Bin/../rep/listado-presupuesto-sancionado-$anio-TC-$i.csv"){
            $i++;
        }
        open(SALIDA,">$FindBin::Bin/../rep/listado-presupuesto-sancionado-$anio-TC-$i.csv") || die "ERROR: No se pudo crear el archivo para el listado\n";
        print SALIDA "Año presupuestario $anio;Total sancionado\n";
        print SALIDA "$centro;$totalCentro\n";
    }
    
    while(<SANCIONADO>){
        chomp($_);
        @reg = split(";",$_);
        if(@reg[1] ne $trimestreAnterior){
            print "Total $trimestreAnterior";
            printf("%41.2f\n",$totalTrimestre);
            print "\n";
            if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
                print SALIDA "Total $trimestreAnterior;$totalTrimestre\n";
            }
            $totalAnual += $totalTrimestre;
            $totalTrimestre = 0;
            $trimestreAnterior = @reg[1];
        }
        $centro = %centros{@reg[0]};
        
        $totalCentro = &sumarDecimales;
        
        $totalTrimestre += $totalCentro;
        printf("%-47s",$centro);
        printf("%21.2f\n",$totalCentro);
        
        if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
            print SALIDA "$centro;$totalCentro\n";
        }
    }
    
    print "Total $trimestreAnterior";
    printf("%41.2f\n",$totalTrimestre);
    $totalAnual += $totalTrimestre;
    print "\n";
    print "Total Anual";
    printf("%57.2f\n",$totalAnual);
    
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        print SALIDA "Total $trimestreAnterior;$totalTrimestre\n";
        print SALIDA "Total Anual;$totalAnual\n";
        close(SALIDA);
    }
    
    close(SANCIONADO);
    print "Presione ENTER para continuar\n";
    <STDIN>;
}

#Presupuesto sancionado ordenado por Código de Centro y luego por trimestre
sub ordenCT{
    &opcListado;
    &abrirCentros;
    open(SANCIONADO,"<$FindBin::Bin/../mae/sancionado-$anio.csv") || die "ERROR: No se pudo abrir el archivo sancionado-$anio.csv\n";
    &generarHashesDeTrimestres;
    
    my $totalCentro = 0;
    my $totalAnual = 0;
    print "Año presupuestario $anio";
    printf("%45s\n",'Total sancionado');
    print "--------------------------------------------------------------------";
    print "\n";
    
    my $i=0;
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        while(-e "$FindBin::Bin/../rep/listado-presupuesto-sancionado-$anio-CT-$i.csv"){
            $i++;
        }
        open(SALIDA,">$FindBin::Bin/../rep/listado-presupuesto-sancionado-$anio-CT-$i.csv") || die "ERROR: No se pudo crear el archivo para el listado\n";
    }
    
    my @arrCentros = keys %centros;
    foreach my $centro (@arrCentros){
        my $sancionado = $primerTrimestre{$centro};
        $totalCentro += $sancionado;
        printf "Primer Trimestre $anio";
        printf("%47.2f\n",$sancionado);
        
        if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
            print SALIDA "Primer Trimestre $anio;$sancionado\n";
        }
        
       $sancionado = $segundoTrimestre{$centro};
        $totalCentro += $sancionado;
        printf "Segundo Trimestre $anio";
        printf("%46.2f\n",$sancionado);
        
        if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
            print SALIDA "Primer Segundo $anio;$sancionado\n";
        }
        
        $sancionado = $tercerTrimestre{$centro};
        $totalCentro += $sancionado;
        printf "Tercer Trimestre $anio";
        printf("%47.2f\n",$sancionado);
        
        if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
            print SALIDA "Tercer Trimestre $anio;$sancionado\n";
        }
        
        $sancionado = $cuartoTrimestre{$centro};
        $totalCentro += $sancionado;
        printf "Cuarto Trimestre $anio";
        printf("%47.2f\n",$sancionado);
        
        if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
            print SALIDA "Cuarto Trimestre $anio;$sancionado\n";
        }
        
        printf("Total %-47s",$centros{$centro});
        printf("%15.2f\n",$totalCentro);
        print "\n";
        
        if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
            print SALIDA "Total $centros{$centro};$totalCentro\n";
        }
        
        $totalAnual += $totalCentro;
        $totalCentro = 0;
    }
    
    printf "Total Anual";
    printf("%57.2f\n",$totalAnual);
    
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        print SALIDA "Total Anual;$totalAnual\n";
        close(SALIDA);
    }
    print "Presione ENTER para continuar\n";
    <STDIN>;
}

sub opcListado(){
    print "Indique el año presupuestario: ";
    chomp($anio = <STDIN>);
    do{
        print "¿Desea generar un archivo de salida con el listado? S/N\n";
        chomp($opcionArchivo = <STDIN>);
    }
    while($opcionArchivo ne "s" && $opcionArchivo ne "S" && $opcionArchivo ne "n" && $opcionArchivo ne "N");
}

sub abrirCentros(){
    open(CENTROS,"<$FindBin::Bin/../mae/centros.csv") || die "ERROR: No se pudo abrir el archivo centros\n";
    %centros;
    #Guardo los centros en un hash con el número de centro como clave.
    <CENTROS>;
    while(<CENTROS>){
        chomp($_);
        @reg = split(";",$_);
        $centros{@reg[0]} = @reg[1];
    }
    
    close(CENTROS);
}

#Esto es para obtener los digitos decimales
sub sumarDecimales(){
    @arr1 = split(",",@reg[2]);
    @arr2 = split(",",@reg[3]);
    $num1 = "@arr1[0].@arr1[1]";
    $num2 = "@arr2[0].@arr2[1]";
    $num1 + $num2;
}

sub generarHashesDeTrimestres(){
    %primerTrimestre;
    %segundoTrimestre;
    %tercerTrimestre;
    %cuartoTrimestre;
    
    <SANCIONADO>;
    chomp(my $linea = <SANCIONADO>);
    @reg = split(";",$linea);
    my $trimestreAnterior = @reg[1];
    $primerTrimestre{@reg[0]} = &sumarDecimales;
    
    while(<SANCIONADO>){
        @reg = split(";",$_);
        if(@reg[1] ne $trimestreAnterior){
            $trimestreAnterior = @reg[1];
            last;
        }
        $primerTrimestre{@reg[0]} = &sumarDecimales;
    }
    
    $segundoTrimestre{@reg[0]} = &sumarDecimales;
    
    while(<SANCIONADO>){
        @reg = split(";",$_);
        if(@reg[1] ne $trimestreAnterior){
            $trimestreAnterior = @reg[1];
            last;
        }
        $segundoTrimestre{@reg[0]} = &sumarDecimales;
    }
    
    $tercerTrimestre{@reg[0]} = &sumarDecimales;
    
    while(<SANCIONADO>){
        @reg = split(";",$_);
        if(@reg[1] ne $trimestreAnterior){
            $trimestreAnterior = @reg[1];
            last;
        }
        $tercerTrimestre{@reg[0]} = &sumarDecimales;
    }
    
    $cuartoTrimestre{@reg[0]} = &sumarDecimales;
    
    while(<SANCIONADO>){
        @reg = split(";",$_);
        $cuartoTrimestre{@reg[0]} = &sumarDecimales;
    }
    
    close(SANCIONADO);
}

sub abrirAXC{
    open(AXC,"<$FindBin::Bin/../mae/tabla-AxC.csv") || die "ERROR: No se pudo abrir el archivo axc\n";
    %axc;
    #Guardo las actividades en un hash con el número de centro como clave.
    <AXC>;
    my @reg;
    while(<AXC>){
        chomp($_);
        @reg = split(";",$_);
        push @{$axc{@reg[1]}}, @reg[0];
    }
    close(AXC);
}

sub filtroProvincia{
	print "Ingrese la provincia\n";
    my $provincia = <STDIN>;
    chomp($provincia);
	local @prov_a_filtrar;
	push @prov_a_filtrar, $provincia;
    &opcListado;
    &abrirAXC;
    &filtrarprov;
}

sub filtrarprov{
    open(EJECUTADO,"<$FindBin::Bin/../imp/ejecutado-$anio.csv") || die "ERROR: No se pudo abrir el archivo ejecutado-$anio.csv\n";
    print "Año presupuestario $anio";
    printf("%45s\n",'Total ejecutado');
    print "--------------------------------------------------------------------";
    print "\n";
    my $i=0;
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        while(-e "$FindBin::Bin/../rep/listado-presupuesto-ejecutado-$anio-$i.csv"){
            $i++;
        }
        open(SALIDA,">$FindBin::Bin/../rep/listado-presupuesto-ejecutado-$anio-$i.csv") || die "ERROR: No se pudo crear el archivo para el listado\n";
        print SALIDA "Fecha;Centro;Nom Cen;Cod Act;Actividad;Trimestre;Gasto;Provincia;Control\n";
    }
    my %totalXProv;
    foreach $prov (@prov_a_filtrar){
        $totalXProv {$prov} = 0;
    }

    <EJECUTADO>;
    my @reg;
    printf("%-10s","Actividad");
    printf("%-20s","Centro");
    printf("%-10s","Gasto");
    print("Gasto Planificado?");
    print ("\n");
    while(<EJECUTADO>){
        chomp($_);
        @reg = split(";",$_);
        if(any {$_ eq @reg[8]} @prov_a_filtrar){
            printf("%-10s", @reg[7]);
            printf("%-20s", @reg[2]);
            printf("%-10s", @reg[5]);
            if(any {$_ eq @reg[7]} @{$axc{@reg[2]}}){
                print ("Si"); 
                if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
                    print SALIDA "@reg[1];@reg[2];@reg[9];@reg[7];@reg[3];@reg[4];@reg[5];@reg[8]; \n";
                }
            }else{
                print ("No");
                if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
                    print SALIDA "@reg[1];@reg[2];@reg[9];@reg[7];@reg[3];@reg[4];@reg[5];@reg[8];Gasto fuera de planificacion\n";
                }               
            }
            print ("\n");
			@aux = split(",",@reg[5]);
			$num = "@aux[0].@aux[1]";
            $totalXProv{@reg[8]} += $num;
            splice( @aux );
        }
    }
    print SALIDA "\n";
    print "--------------------------------------------------------------------\n";
    foreach $prov (@prov_a_filtrar){
        print "Total $prov: $totalXProv{$prov}\n";
        if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
            print SALIDA "Total $prov;$totalXProv{$prov}\n";
        }   
    }
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        close(SALIDA);
    }  
    close(EJECUTADO);
    print "Presione ENTER para continuar\n";
    <STDIN>;
}

sub abrirProvincias{
    open(PROVINCIAS,"<$FindBin::Bin/../mae/provincias.csv") || die "ERROR: No se pudo abrir el archivo provincias\n";
    @prov_a_filtrar;
    my @reg;
    <PROVINCIAS>;
    while(<PROVINCIAS>){
        chomp($_);
        @reg = split(";",$_);
        push @prov_a_filtrar, @reg[1];
    }
    close(PROVINCIAS);
}

sub filtroProvincias{
    print "Ingrese las provincias separadas por un ;\n";
    my $provincias = <STDIN>;
    chomp($provincias);
    local @prov_a_filtrar = split(";",$provincias);
    &opcListado;
    &abrirAXC;
    &filtrarprov;
}

sub sinFiltro{
	local @prov_a_filtrar;
    &opcListado;
    &abrirProvincias;
    &abrirAXC;
    &filtrarprov;
}
sub trim_a_str{
	my $i =0;
	foreach $trim (@Trimestres_filtrados){
		if($trim eq "1"){
			@Trimestres_filtrados[$i]= sprintf("%s","Primer Trimestre $anio");
		}
		elsif($trim eq "2"){
			@Trimestres_filtrados[$i]= sprintf("%s","Segundo Trimestre $anio");
		}
		elsif($trim eq "3"){
			@Trimestres_filtrados[$i]= sprintf("%s","Tercer Trimestre $anio");
		}
		elsif($trim eq "4"){
			@Trimestres_filtrados[$i]= sprintf("%s","Cuarto Trimestre $anio");
		}
		$i++;
	}
}
sub fechastrimestres{
    open(EJECUTADO,"<$FindBin::Bin/../mae/trimestres.csv") || die "ERROR: No se pudo abrir el archivo de fechas.csv\n";
    while(<EJECUTADO>){
        chomp($_);
        @reg = split(";",$_);
        @fecha_aux= split("/",@reg[2]);
        $fechaInicioTrim{@reg[1]} = "@fecha_aux[2]@fecha_aux[1]@fecha_aux[0]";
    }
}

sub generarListadoControlEjecutado{
    local %fechaInicioTrim;
	&opcListado;
	&abrirAXC;
	&trim_a_str;
    &fechastrimestres;
	open(EJECUTADO,"<$FindBin::Bin/../imp/ejecutado-$anio.csv") || die "ERROR: No se pudo abrir el archivo ejecutado-$anio.csv\n";
	open(SANCIONADO,"<$FindBin::Bin/../mae/sancionado-$anio.csv") || die "ERROR: No se pudo abrir el archivo sancionado-$anio.csv\n";
    print "Año presupuestario $anio";
    printf("%45s\n",'Control total ejecutado');
    print "--------------------------------------------------------------------";
    print "\n";
	my %sancionadoXCentro_Trim;
	my %regXCentro_Fecha;
    local $i=0;
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        while(-e "$FindBin::Bin/../rep/listado-control-presupuesto-ejecutado-$anio-$i.csv"){
            $i++;
        }
        open(SALIDA,">$FindBin::Bin/../rep/listado-control-presupuesto-ejecutado-$anio-$i.csv") || die "ERROR: No se pudo crear el archivo para el listado\n";
        print SALIDA "ID;FECHA;CENTRO;ACTIVIDAD;TRIMESTRE;IMPORTE;SALDO por TRIMESTRE;CONTROL;SALDO ACUMULADO\n";
    }
	my @reg_hash;
    print "FECHA   | CENTRO | TRIMESTRE\nIMPORTE | SALDO x TRIM | SALDO ACUMULADO | GASTO PLANIFICADO | PRESUPUESTO EXCEDIDO\n";
    while(<EJECUTADO>){
        chomp($_);
        @reg = split(";",$_);
        if(any {$_ eq @reg[2]} @Centros_filtrados){			
            if(any {$_ eq @reg[4]} @Trimestres_filtrados){            
				@reg_hash = split(";","@reg[0];@reg[4];-@reg[5];@reg[3];@reg[7]");
            	push @{$regXCentro_Fecha{@reg[2]}{@reg[1]}},@reg_hash ;
            }
        }
    }
    while(<SANCIONADO>){
        chomp($_);
        @reg = split(";",$_);
        if(any {$_ eq @reg[0]} @Centros_filtrados){			
            if(any {$_ eq @reg[1]} @Trimestres_filtrados){            
            	$sancionadoXCentro_Trim{@reg[0]}{@reg[1]} += &sumarDecimales;
            }
        }
    }

    foreach $centro (keys %sancionadoXCentro_Trim){
        foreach $trim (keys %{%sancionadoXCentro_Trim{$centro}}){
            @reg_hash = split(";","(++);$trim;$sancionadoXCentro_Trim{$centro}{$trim};0");
            push @{$regXCentro_Fecha{$centro}{$fechaInicioTrim{$trim}}},@reg_hash;
        }
    }

    my $saldoTrimestre;
    my $saldoAcum;
    my $trimAnterior;
    my $control;
    foreach my $centro (keys %regXCentro_Fecha){
        $saldoAcum = 0;
        $trimAnterior;
        $saldoTrimestre = 0;
        $i = 0;
        foreach my $fecha (sort {$a <=> $b} keys %{%regXCentro_Fecha{$centro}}){ 
            if (($trimAnterior ne $regXCentro_Fecha{$centro}{$fecha}[1]) && ($i > 0)){
                $saldoTrimestre = 0; 
                print"\n";
            }
            $trimAnterior = sprintf("%s",$regXCentro_Fecha{$centro}{$fecha}[1]);
            $i++;
            printf("%-8s|",$fecha);
            printf("%-13s|",$centro);
            printf("%-22s|\n",$regXCentro_Fecha{$centro}{$fecha}[1]);
            printf("%-5.2f|",$regXCentro_Fecha{$centro}{$fecha}[2]); #IMPORTE
            @aux = split(",",$regXCentro_Fecha{$centro}{$fecha}[2]);
            $num = "@aux[0].@aux[1]";
            $saldoTrimestre += $num;
            $saldoAcum += $num;
            splice( @aux );
            printf("%-5.2f|",$saldoTrimestre);#SALDO ACUMULADO TRIMESTRE-CENTRO
            printf("%-5.2f|",$saldoAcum);#SALDO TOTAL CENTRO
            if($regXCentro_Fecha{$centro}{$fecha}[0] ne "(++)"){
                if(any {$_ eq $regXCentro_Fecha{$centro}{$fecha}[4]} @{$axc{$centro}}){
                    print (" Si |");
                    if($saldoTrimestre<0){
                        print (" Si\n");
                        $control = sprintf("%s","Presupuesto excedido");
                    }else{
                        print (" No\n");
                        $control = sprintf("%s"," ");
                    }

                }else{
                    print (" No |"); 
                    if($saldoTrimestre<0){
                        print (" Si\n");
                        $control = sprintf("%s","Gasto no planificado,Presupuesto excedido");
                    }else{
                        print (" No\n");
                        $control = sprintf("%s","Gasto no planificado");
                    }
                }               
            }else{
                print "(++)\n";
                $control = sprintf("%s"," ");
            }
            if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
                print SALIDA "$regXCentro_Fecha{$centro}{$fecha}[0];";
                print SALIDA "$fecha;";
                print SALIDA "$centro;";
                print SALIDA "$regXCentro_Fecha{$centro}{$fecha}[3];";
                print SALIDA "$regXCentro_Fecha{$centro}{$fecha}[1];";
                printf SALIDA "%4.2f;",$regXCentro_Fecha{$centro}{$fecha}[2];
                printf SALIDA "%4.2f;",$saldoTrimestre;
                printf SALIDA "%-15s;",$control;
                printf SALIDA "%-4.2f\n",$saldoAcum;
            }
        }
        print"\n";
        print"\n";
    }
    close(EJECUTADO);
    close(SANCIONADO);
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        close(SALIDA);
    }
    print "Presione ENTER para continuar\n";
    <STDIN>;
}

&menu;
