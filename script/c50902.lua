 
--装备开发
function c50902.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c50902.cost)
	e1:SetTarget(c50902.target)
	e1:SetOperation(c50902.operation)
	c:RegisterEffect(e1)
end
function c50902.filter1(c,setcode)
	return c:IsSetCard(setcode) and c:IsAbleToHand()
end
function unpack(t, i)
    i = i or 1
    if t[i] then
       return t[i], unpack(t, i + 1)
    end
end
function c50902.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b = {}
	local count = 0
	if(Duel.CheckLPCost(tp,200) and Duel.IsExistingMatchingCard(c50902.filter1,tp,LOCATION_DECK,0,3,nil,0x4db)) then 
		count = count + 1
		b[count] = 200
	end
	if(Duel.CheckLPCost(tp,300) and Duel.IsExistingMatchingCard(c50902.filter1,tp,LOCATION_DECK,0,3,nil,0x11c)) then 
		count = count + 1
		b[count] = 300
	end
	if(Duel.CheckLPCost(tp,600) and Duel.IsExistingMatchingCard(c50902.filter1,tp,LOCATION_DECK,0,3,nil,0x1bb)) then 
		count = count + 1
		b[count] = 600
	end
	
	if chk==0 then return (count>0) end
	local alp=200
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50902,0))
	alp=Duel.AnnounceNumber(tp,unpack(b))
	Duel.PayLPCost(tp,alp)
	e:SetLabel(alp)
end
function c50902.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c50902.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local alp = e:GetLabel()
	local g = Group.CreateGroup()
	if alp == 200 then
		g=Duel.GetMatchingGroup(c50902.filter1,tp,LOCATION_DECK,0,nil,0x4db)
	elseif alp == 300 then
		g=Duel.GetMatchingGroup(c50902.filter1,tp,LOCATION_DECK,0,nil,0x11c)
	elseif alp == 600 then
		g=Duel.GetMatchingGroup(c50902.filter1,tp,LOCATION_DECK,0,nil,0x1bb)
	end
	
	if g:GetCount()>=3 then
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end