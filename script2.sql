-- criação de banco de dados para o cenário de E-commerce
drop database ecommerce;
create database ecommerce;

use ecommerce;

-- criar tabela cliente;
-- drop table clients;
create table clients(
	idClient int auto_increment primary key,
    CPF char(11),
    CNPJ char(15),
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    Address varchar(100),
    constraint fk_pf foreign key(CPF) references pf(CPF),
    constraint fk_pj foreign key(CNPJ) references pj(CNPJ)
);
desc clients;
alter table clients auto_increment=1;

-- criar tabelas de PF e PJ

create table pf(
	idPf int primary key auto_increment,
    CPF char(11),
    birthDate date not null,
    constraint unique_cpf_client unique(CPF)
);

create table pj(
	idPj int primary key auto_increment,
    CNPJ char(15),
    constraint unique_cnpj_client unique(CNPJ)
    );

-- criar tabela produto


-- size = dimensão do produto
-- drop table product;
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(20) not null,
    classification_kids bool default false,
    category enum('Lazer','Eletrônico','Vestimenta','Brinquedo','Alimento'),
    Avaliação float default 0,
    size varchar(10)
);

alter table product modify column Pname varchar(45);



-- criar tabela de pagamento
-- drop table payments;
create table payments(
	idPayment int,
	idPayClient int,
    idPpayment int,
    typePayment enum('Boleto','Cartão'),
    statusPayment varchar(45),
    primary key(idPayment,idPayClient,idPpayment),
    constraint fk_id_payclient foreign key(idPayClient) references clients(idClient),
    constraint fk_id_payorder foreign key(idPpayment) references orders(idPedido)
);
-- desc payments;
create table cartao(
	idCartao int primary key,
    idPayCard int,
    idclientCard int,
    idOrdCard int,
    validate char(4) not null,
    cvv char(3) not null,
    nameCard varchar(45) not null,
    numberCard varchar(45) not null,
    constraint fk_idpay_cartao foreign key (idPayCard) references payments(IdPayment),
    constraint fk_idclient_cartao foreign key(idclientCard) references clients(idClient),
    constraint fk_idpedido_cartao foreign key(idOrdCard) references orders(idPedido)
);


create table boleto(
	idBoleto int primary key,
    idPayBol int,
    idClientBol int,
    idOrdBol int,
    vencimento date,
    constraint fk_idpay_boleto foreign key (idPayBol) references payments(IdPayment),
    constraint fk_idclient_boleto foreign key(idClientBol) references clients(idClient),
    constraint fk_idpedido_boleto foreign key(idOrdBol) references orders(idPedido)
);
    
-- criar tabela de pedido
create table orders(
	idPedido int auto_increment primary key,
    idOrderClient int,
    statusPedido enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
	constraint fk_order_client foreign key (idOrderClient) references clients(idClient)
);

desc orders;


create table confirmation(
	idConfirmation int primary key,
    idPayConfirmation int,
    idClientConfirmation int,
    idOrdConfirmation int,
    statusPEnvio enum('Preparando para enviar', 'Enviado'),    
	constraint fk_idpay_confirm foreign key (idPayConfirmation) references payments(IdPayment),
    constraint fk_idclient_confirm foreign key(idClientConfirmation) references clients(idClient),
    constraint fk_idpedido_confirm foreign key(idOrdConfirmation) references orders(idPedido)
);

create table delivery(
	idDelivery int primary key,
    idPayDelivery int,
    idClientDelivery int,
    idOrdDelivery int,
    codRastreio varchar(45),
    constraint fk_idpay_delivery foreign key (idPayDelivery) references payments(IdPayment),
    constraint fk_idclient_delivery foreign key(idClientDelivery) references clients(idClient),
    constraint fk_idpedido_delivery foreign key(idOrdDelivery) references orders(idPedido)
);


-- criar tabela de estoque
create table productStorage(
	idProdutoStorage int auto_increment primary key,
    Category enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    storageLocation varchar (255),
    quantity int default 0
);


-- criar tabela de fornecedor 


create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique(CNPJ)
);
desc supplier;

-- criar tabela de vendedor
-- drop table seller;
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char (11),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique(CNPJ),
    constraint unique_cpf_seller unique(CPF)
);
desc seller;
-- criar tabela de produto por vendedor

create table productSeller(
	idPseller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idPseller, idProduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);
desc productSeller;


create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus varchar(45),
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idPedido)
);


create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storageLocation_seller foreign key (idLproduct) references product(idProduct),
    constraint fk_storageLocation_product foreign key (idLstorage) references orders(idPedido)
);


create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int default 1,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_seller foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

show tables;