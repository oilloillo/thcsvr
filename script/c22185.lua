 
--七曜-日水符「氢化日珥」
function c22185.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22185.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22185,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22185.acttg)
	e2:SetOperation(c22185.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22185.actcon)
	c:RegisterEffect(e3)
	--d&d
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22185,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c22185.cost)
	e4:SetTarget(c22185.target)
	e4:SetOperation(c22185.operation)
	c:RegisterEffect(e4)
end
function c22185.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22185)==1
end
function c22185.actfilter1(c)
	return c:IsSetCard(0x183) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22185.actfilter2(c)
	return c:IsSetCard(0x179) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22185.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22185.actfilter1,tp,LOCATION_SZONE,0,1,nil) and 
		Duel.IsExistingMatchingCard(c22185.actfilter2,tp,LOCATION_SZONE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(22185,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22185.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c22185.actfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22185.actfilter2,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
		if Duel.SendtoGrave(g1,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22185.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22185.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22185.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22185.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c22185.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c22185.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22185.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingTarget(c22185.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	local g=Duel.SelectTarget(tp,c22185.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c22185.spfilter(c,e,tp,tap,tc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:GetOwner()==tap and c~=tc
end
function c22185.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			local tap=tc:GetOwner()
			local g=Duel.SelectMatchingCard(tap,c22185.spfilter,tap,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,tap,tc)
			Duel.SpecialSummon(g,0,tap,tap,false,false,POS_FACEUP)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
