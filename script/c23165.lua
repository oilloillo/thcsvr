--名存实亡的神明✿洩矢诹访子
function c23165.initial_effect(c)
	c:SetUniqueOnField(1,0,23165)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,c23165.ovfilter,aux.Stringid(23165,0))
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(23165,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c23165.cost)
	e1:SetTarget(c23165.target)
	e1:SetOperation(c23165.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c23165.atkval)
	c:RegisterEffect(e2)
	--def up
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENCE)
	c:RegisterEffect(e3)
end
function c23165.ovfilter(c)
	return c:IsFaceup() and c:GetCounter(0x28a)>0
end
function c23165.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c23165.filter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c23165.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23165.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c23165.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23165.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local code=g:GetFirst():GetCode()
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local sg=fg:Filter(Card.IsCode,nil,code)
		if sg:GetCount()>0 then
			local ct=e:GetHandler():GetOverlayCount()+5
			local tc=sg:GetFirst()
			while tc do
				tc:AddCounter(0x28a,ct)
				local cp=tc:GetControler()
				if Duel.GetFlagEffect(cp,23200)==0 then
					Duel.RegisterFlagEffect(cp,23200,0,0,0)
				end
				tc=sg:GetNext()
			end
		end
	end
end
function c23165.atkval(e,c)
	return Duel.GetCounter(c:GetControler(),1,1,0x28a)*300
end
