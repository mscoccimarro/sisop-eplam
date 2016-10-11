#!/usr/bin/perl
use FindBin;

#Menú
sub menu{
    print "********************LISTADO********************\n";
    print "* 1. Listar Presupuesto Sancionado.           *\n";
    print "* 2. Ayuda del comando.                       *\n";
    print "* 3. Salir.                                   *\n";
    print "***********************************************\n";
    
    my $opcion = <STDIN>;
    chomp($opcion);
    
    if($opcion eq "1"){
        &listadoPresupuestoSancionado;
        &menu;
    }
    if($opcion eq "2"){
        &ayudaComando;
        &menu;
    }
    if($opcion eq "3"){
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
    
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        open(SALIDA,">$FindBin::Bin/../rep/listado-presupuesto-sancionado-$anio-TC.csv") || die "ERROR: No se pudo crear el archivo para el listado\n";
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
    
    if($opcionArchivo eq "s" || $opcionArchivo eq "S"){
        open(SALIDA,">$FindBin::Bin/../rep/listado-presupuesto-sancionado-$anio-CT.csv") || die "ERROR: No se pudo crear el archivo para el listado\n";
        print SALIDA "Año presupuestario $anio;Total sancionado\n";
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

=sub obtenerPathDIRMAE(){
    open(CONF,"<dirconf/Instalep.conf") || die "ERROR: No se pudo abrir el archivo Instalep.conf\n";
    
    #Obtengo el path de DIRMAE
    while(<CONF>){
        @reg = split("=",$_);
        if(@reg[0] eq "DIRMAE"){
            $path = @reg[1];
            last;
        }
    }
    close(CONF);
}
=cut

&menu;