 
--舰船建造
function c50901.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c50901.cost)
	e1:SetTarget(c50901.target)
	e1:SetOperation(c50901.operation)
	c:RegisterEffect(e1)
end
function c50901.filter1(c,setcode,flag)
	local b1 = true
	if flag == 1 then
		b1 = (c:GetLevel()<=4)
	elseif flag == 2 then
		b1 = (c:GetLevel()>4)
	end
	return c:IsSetCard(setcode) and b1 and c:IsAbleToHand()
end
function unpack(t, i)
    i = i or 1
    if t[i] then
       return t[i], unpack(t, i + 1)
    end
end
function c50901.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b = {}
	local count = 0
	if(Duel.CheckLPCost(tp,100) and Duel.IsExistingMatchingCard(c50901.filter1,tp,LOCATION_DECK,0,3,nil,0x54bb,0)) then 
		count = count + 1
		b[count] = 100
	end
	if(Duel.CheckLPCost(tp,300) and Duel.IsExistingMatchingCard(c50901.filter1,tp,LOCATION_DECK,0,3,nil,0xc4bb,1)) then 
		count = count + 1
		b[count] = 300
	end
	if(Duel.CheckLPCost(tp,600) and Duel.IsExistingMatchingCard(c50901.filter1,tp,LOCATION_DECK,0,3,nil,0x64bb,0)) then 
		count = count + 1
		b[count] = 600
	end
	if(Duel.CheckLPCost(tp,700) and Duel.IsExistingMatchingCard(c50901.filter1,tp,LOCATION_DECK,0,3,nil,0xc4bb,2)) then 
		count = count + 1
		b[count] = 700
	end
	
	if chk==0 then return (count>0) end
	local alp=100
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50901,0))
	alp=Duel.AnnounceNumber(tp,unpack(b))
	Duel.PayLPCost(tp,alp)
	e:SetLabel(alp)
end
function c50901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c50901.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local alp = e:GetLabel()
	local g = Group.CreateGroup()
	if alp == 100 then
		g=Duel.GetMatchingGroup(c50901.filter1,tp,LOCATION_DECK,0,nil,0x54bb,0)
	elseif alp == 300 then
		g=Duel.GetMatchingGroup(c50901.filter1,tp,LOCATION_DECK,0,nil,0xc4bb,1)
	elseif alp == 600 then
		g=Duel.GetMatchingGroup(c50901.filter1,tp,LOCATION_DECK,0,nil,0x64bb,0)
	elseif alp == 700 then
		g=Duel.GetMatchingGroup(c50901.filter1,tp,LOCATION_DECK,0,nil,0xc4bb,2)
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