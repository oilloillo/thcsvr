--✿不可思议仙境的爱丽丝✿
function c15059.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Nef.AddXyzProcedureWithDesc(c,nil,4,2,aux.Stringid(15059,0))
	-- xyzop
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15059,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c15059.xyzcon)
	e1:SetOperation(c15059.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15059,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c15059.thcost)
	e2:SetTarget(c15059.thtg)
	e2:SetOperation(c15059.thop)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15059,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c15059.target)
	e3:SetOperation(c15059.operation)
	c:RegisterEffect(e3)
	if c15059.counter==nil then
		c15059.counter=true
		c15059[0]=0
		c15059[1]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c15059.resetcount)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_CHAINING)
		e5:SetOperation(c15059.addcount)
		Duel.RegisterEffect(e5,0)
	end
end
function c15059.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c15059[0]=0
	c15059[1]=0
end
function c15059.addcount(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) then return end
	c15059[rp]=c15059[rp]+1
end
function c15059.hofilter(c, tp, xyzc, lv)
	if c:IsType(TYPE_TOKEN) or not c:IsCanBeXyzMaterial(xyzc) then return false end
	return c:IsSetCard(0x300) and c:IsFaceup() and c:IsLevelBelow(4)
end
function c15059.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c15059.hofilter, tp, LOCATION_MZONE, 0, 1, nil, tp, c)
end
function c15059.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local mg = Duel.SelectMatchingCard(tp, c15059.hofilter, tp, LOCATION_MZONE, 0, 1, 1, nil, tp, c)
	if mg:GetCount()<1 then return end
	c:SetMaterial(mg)
	Duel.Overlay(c, mg)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x0fe0000)
	c:RegisterEffect(e1,true)
end
function c15059.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c15059.desfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c15059.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15059.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c15059.desfilter,tp,0,LOCATION_MZONE,nil)
	local dg=g:GetMaxGroup(Card.GetDefense)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,dg,dg:GetCount(),0,0)
end
function c15059.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15059.desfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local dg=g:GetMaxGroup(Card.GetDefense)
		Duel.SendtoHand(dg,nil,REASON_EFFECT)
	end
end
function c15059.filter(c)
	return c:IsType(TYPE_SPELL)
end
function c15059.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c15059.filter(chkc) end
	if chk==0 then return c15059[tp]>0 and Duel.IsExistingTarget(c15059.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c15059.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
end
function c15059.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Overlay(e:GetHandler(),tc)
	end
end
