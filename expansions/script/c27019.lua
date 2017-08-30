 
--狸猫怪 二岩猯藏
function c27019.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),6,2,c27019.ovfilter,aux.Stringid(27019,0))
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27019,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c27019.cost)
	e1:SetTarget(c27019.target)
	e1:SetOperation(c27019.operation)
	c:RegisterEffect(e1)
end
function c27019.ovfilter(c)
	return c:IsFaceup() and c:IsCode(26020)
end
function c27019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27019.filter(c,ec)
	if c:IsFacedown() or bit.band(c:GetOriginalType(),TYPE_MONSTER)==0 then return false end
	local effect_code=ec:GetFlagEffectLabel(27019)
	if not effect_code then return true end
	local effect_list=Nef.order_table[effect_code]
	for _,rcode in pairs(effect_list) do
		if rcode==c:GetOriginalCode() then return false end
	end
	return true
end
function c27019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk~=0 then return end
	return Duel.IsExistingMatchingCard(c27019.filter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler())
end
function c27019.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	local wg=Duel.GetMatchingGroup(c27019.filter,tp,0,LOCATION_MZONE,nil,c)
	local wbc=wg:GetFirst()
	while wbc do
		if c27019.filter(wbc,c) then
			local code=wbc:GetOriginalCode()
			local effect_code=c:GetFlagEffectLabel(27019)
			c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			if not effect_code then
				c:RegisterFlagEffect(27019,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,Nef.order_table_new({code}))
			else
				table.insert(Nef.order_table[effect_code],code)
			end
		end
		wbc=wg:GetNext()
	end	 
end
