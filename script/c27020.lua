 
--狸猫怪 二岩猯藏
function c27020.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),6,2,c27020.ovfilter,aux.Stringid(27019,0))
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27019,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c27020.cost)
	e1:SetOperation(c27020.operation)
	c:RegisterEffect(e1)
end
function c27020.ovfilter(c)
	return c:IsFaceup() and c:IsCode(26020)
end
function c27020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27020.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local wg=Duel.GetMatchingGroup(nil,c:GetControler(),0,LOCATION_MZONE,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()*12
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
		c:CopyEffect(wbc:GetOriginalCode(), RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1) 	
		end	
		wbc=wg:GetNext()
	end		
end
